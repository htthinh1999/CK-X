# CKAD Multi-Cluster Exam C — Transit Authority: Answers

Each question runs on the server shown under its heading: `ssh` to that host and work with its default (and only) context — one cluster per host. Task files live under `/home/candidate/exam/q<N>/` on that server.

---

## Question 1 | Orphaned Opaque Secrets

> Server: `ssh ckad9999`

```bash
cd /home/candidate/exam/q1
kubectl -n ticketing get secrets
kubectl -n ticketing get pods

# Every Secret name referenced by a Pod: env secretKeyRef, envFrom secretRef,
# secret volumes and projected secret sources, in containers AND init containers
kubectl -n ticketing get pods -o json | jq -r '
  .items[].spec
  | ( ((.containers // []) + (.initContainers // []) + (.ephemeralContainers // []))[]
      | ((.env // [])[] | .valueFrom.secretKeyRef.name // empty),
        ((.envFrom // [])[] | .secretRef.name // empty) ),
    ( (.volumes // [])[]
      | (.secret.secretName // empty),
        ((.projected.sources // [])[] | .secret.name // empty) )' | sort -u > referenced.txt

kubectl -n ticketing get secrets -o json \
  | jq -r '.items[] | select(.type=="Opaque") | .metadata.name' | sort > opaque.txt

comm -23 opaque.txt referenced.txt > orphaned-secrets.txt
cat orphaned-secrets.txt
# barrier-api-key
# fare-rules
# legacy-smartcard-key
# promo-codes-2024

# ledger-db-creds still carries a stale label from an earlier audit
kubectl -n ticketing get secrets -l lifecycle=orphaned
kubectl -n ticketing label secret ledger-db-creds lifecycle-
kubectl -n ticketing label secret $(cat orphaned-secrets.txt) lifecycle=orphaned --overwrite
kubectl -n ticketing get secrets -l lifecycle=orphaned
```

Match on the reference fields themselves, not on names found anywhere in the Pod YAML: `fare-rules` is only used as a ConfigMap, `promo-codes-2024` is only a volume *name*, `legacy-smartcard-key` only appears in an annotation and `barrier-api-key` is a prefix of the referenced `barrier-api-key-v2`. `night-bus-token` (init container) and `validator-hmac` (projected volume) are referenced, and non-Opaque Secrets (tls, dockerconfigjson, basic-auth) are out of scope.

---

## Question 2 | Pending Pods on a tainted node

> Server: `ssh ckad9999`

```bash
kubectl -n depot get pods -o wide
kubectl -n depot describe pod -l app=wagon-sorter | grep -A4 Events
#  0/2 nodes are available: 1 node(s) didn't match Pod's node affinity/selector,
#  1 node(s) had untolerated taint {dedicated: depot}
kubectl get nodes -L transit.io/pool,transit.io/lane
NODE=$(kubectl get nodes -l transit.io/pool=depot -o jsonpath='{.items[0].metadata.name}')
kubectl describe node "$NODE" | grep -A2 Taints          # dedicated=depot:NoSchedule
kubectl -n depot get deployment wagon-sorter -o yaml     # toleration has effect NoExecute,
                                                         # affinity also requires lane=freight-a
# Tolerate the NoSchedule taint and require the lane the depot node actually has
kubectl -n depot patch deployment wagon-sorter --type=json -p '[
  {"op":"replace","path":"/spec/template/spec/tolerations/0/effect","value":"NoSchedule"},
  {"op":"replace","path":"/spec/template/spec/affinity/nodeAffinity/requiredDuringSchedulingIgnoredDuringExecution/nodeSelectorTerms/0/matchExpressions/1/values","value":["freight-b"]}]'
kubectl -n depot rollout status deployment/wagon-sorter --timeout=120s
kubectl -n depot get pods -l app=wagon-sorter -o wide

echo "$NODE" > /home/candidate/exam/q2/depot-node.txt
```

There are two faults: the existing toleration only covers `NoExecute`, and once it tolerates `NoSchedule` the Pods are still Pending because the required affinity also asks for `transit.io/lane=freight-a` (the scheduler reports the taint first, then the affinity). Keep a required rule that selects only the depot node (fixing or dropping the lane expression both work). Removing the affinity and only adding a toleration would let Pods land on other nodes too.

---

## Question 3 | Init container rendering config via the downward API

> Server: `ssh ckad9999`

```bash
kubectl -n signals get configmap box-template -o yaml

cat > /home/candidate/exam/q3/signal-box.yaml <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: signal-box
  namespace: signals
spec:
  initContainers:
  - name: render
    image: busybox:1.36
    env:
    - name: POD_NAME
      valueFrom:
        fieldRef:
          fieldPath: metadata.name
    - name: NODE_NAME
      valueFrom:
        fieldRef:
          fieldPath: spec.nodeName
    - name: CPU_LIMIT
      valueFrom:
        resourceFieldRef:
          containerName: box
          resource: limits.cpu
          divisor: 1m
    command:
    - sh
    - -c
    - sed -e "s/%POD_NAME%/$POD_NAME/g" -e "s/%NODE_NAME%/$NODE_NAME/g" -e "s/%CPU_LIMIT%/$CPU_LIMIT/g" /tpl/box.conf.tpl > /config/box.conf
    volumeMounts:
    - name: tpl
      mountPath: /tpl
    - name: config
      mountPath: /config
  containers:
  - name: box
    image: nginx:1.25
    resources:
      limits:
        cpu: 250m
    volumeMounts:
    - name: config
      mountPath: /etc/signal
  volumes:
  - name: tpl
    configMap:
      name: box-template
  - name: config
    emptyDir: {}
YAML
kubectl apply -f /home/candidate/exam/q3/signal-box.yaml
kubectl -n signals wait --for=condition=Ready pod/signal-box --timeout=120s
kubectl -n signals exec signal-box -c box -- cat /etc/signal/box.conf
```

`spec.nodeName` is only available as an env `fieldRef`, not in a downwardAPI volume. The `resourceFieldRef` needs `containerName: box` (otherwise it reads the init container's own limit, which is unset) and `divisor: 1m` (the default divisor 1 rounds 250m up to `1`); `sed` needs the `g` flag because one line contains `%POD_NAME%` twice.

---

## Question 4 | Build with build arguments, push to the local registry, deploy

> Server: `ssh ckad9999`

```bash
cd /home/candidate/exam/q4/app
cat Dockerfile
docker build --build-arg DISPATCH_ZONE=riverside --build-arg BUILD_NO=417 -t localhost:5000/dispatch-board:2.3 .
docker image inspect localhost:5000/dispatch-board:2.3 --format '{{json .Config.Labels}}'
#  transit.dispatch/zone is empty and release is "-417": DISPATCH_ZONE is only declared
#  before FROM, so it is not in scope inside the build stage. Re-declare it after FROM:
sed -i 's/^ARG BUILD_NO=100$/ARG DISPATCH_ZONE\nARG BUILD_NO=100/' Dockerfile
docker build --build-arg DISPATCH_ZONE=riverside --build-arg BUILD_NO=417 -t localhost:5000/dispatch-board:2.3 .
docker image inspect localhost:5000/dispatch-board:2.3 --format '{{json .Config.Labels}}'
docker run --rm localhost:5000/dispatch-board:2.3 cat /usr/share/nginx/html/index.html | grep zone=

docker push localhost:5000/dispatch-board:2.3
curl -s http://localhost:5000/v2/dispatch-board/tags/list

docker image inspect localhost:5000/dispatch-board:2.3 \
  --format '{{ index .Config.Labels "transit.dispatch/release" }}' > /home/candidate/exam/q4/release.txt
cat /home/candidate/exam/q4/release.txt          # riverside-417

kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dispatch-board
  namespace: dispatch
spec:
  replicas: 2
  selector:
    matchLabels: {app: dispatch-board}
  template:
    metadata:
      labels: {app: dispatch-board}
    spec:
      containers:
      - name: board
        image: localhost:5000/dispatch-board:2.3
YAML
kubectl -n dispatch rollout status deployment/dispatch-board --timeout=120s
kubectl -n dispatch exec deploy/dispatch-board -c board -- cat /usr/share/nginx/html/index.html
```

An `ARG` declared before the first `FROM` can only be used in `FROM` lines; inside the stage it must be declared again (`ARG DISPATCH_ZONE`) to receive the build argument. If you deployed the broken image first, re-pushing the same tag is not enough: with the default `IfNotPresent` pull policy the nodes keep the cached image, so set `imagePullPolicy: Always` and restart the rollout.

---

## Question 5 | Ingress with Traefik, named Service ports and a decoy Service

> Server: `ssh ckad9999`

```bash
kubectl -n platform get deploy,svc,endpoints -o wide
kubectl -n platform get svc arrivals arrivals-live -o yaml | grep -A6 -E 'ports:|selector:'
#  Service "arrivals" selects track=legacy (arrivals-legacy); the arrivals-web Pods are
#  behind "arrivals-live", whose only port is named "board" (8081 -> targetPort web)

kubectl -n platform create ingress platform-board --class=traefik \
  --rule="board.transit.local/departures*=departures:80" \
  --rule="board.transit.local/arrivals*=arrivals-live:board"
kubectl -n platform get ingress platform-board -o yaml

kubectl -n platform run q5-departures --image=busybox:1.36 --restart=Never --rm -i -- \
  wget -qO- --header 'Host: board.transit.local' http://traefik.kube-system/departures/next \
  > /home/candidate/exam/q5/departures.out
kubectl -n platform run q5-arrivals --image=busybox:1.36 --restart=Never --rm -i -- \
  wget -qO- --header 'Host: board.transit.local' http://traefik.kube-system/arrivals/next \
  > /home/candidate/exam/q5/arrivals.out
cat /home/candidate/exam/q5/departures.out /home/candidate/exam/q5/arrivals.out
```

The `*` in `kubectl create ingress --rule` makes the path `Prefix` (without it the path is `Exact` and `/departures/next` would not match). An Ingress backend refers to a *Service* port (number `8081` or name `board`), not to the container port. The responses echo the `X-Forwarded-Host` header that Traefik adds, which shows the request really went through the ingress controller.

---

## Question 6 | Least-privilege ServiceAccount with resourceNames

> Server: `ssh ckad9999`

```bash
kubectl -n freight create serviceaccount freight-reader
kubectl -n freight create role freight-reader --verb=get,list,watch --resource=configmaps
kubectl -n freight get role freight-reader -o json \
  | jq '.rules += [{"apiGroups":[""],"resources":["secrets"],"resourceNames":["route-key"],"verbs":["get"]}]' \
  | kubectl replace -f -
kubectl -n freight create rolebinding freight-reader --role=freight-reader \
  --serviceaccount=freight:freight-reader

# The SA already has far more than that: an existing binding grants it ClusterRole edit
kubectl auth can-i --list -n freight --as=system:serviceaccount:freight:freight-reader
kubectl -n freight get rolebindings -o wide
# Remove only the ServiceAccount subject from freight-oncall; yardmaster must keep edit
kubectl -n freight get rolebinding freight-oncall -o json \
  | jq '.subjects |= map(select(.kind != "ServiceAccount" or .name != "freight-reader"))' \
  | kubectl replace -f -

# Run as freight-reader; the template disables token automount, so turn it back on
kubectl -n freight patch deployment freight-api --type=merge -p \
  '{"spec":{"template":{"spec":{"serviceAccountName":"freight-reader","automountServiceAccountToken":true}}}}'
kubectl -n freight rollout status deployment/freight-api --timeout=120s

SA=system:serviceaccount:freight:freight-reader
{ kubectl auth can-i watch configmaps -n freight --as=$SA
  kubectl auth can-i get secret/route-key -n freight --as=$SA
  kubectl auth can-i get secret/tariff-db -n freight --as=$SA
} > /home/candidate/exam/q6/can-i.txt
cat /home/candidate/exam/q6/can-i.txt            # yes / yes / no
```

RBAC is additive, so a correct new Role is not enough when an older RoleBinding (`freight-oncall` -> `edit`) already names the ServiceAccount. Delete only that subject, because deleting the whole binding would also take away `yardmaster`'s access. `resourceNames` limits `get` to `route-key`, and a rule without it would expose `tariff-db` as well.

---

## Question 7 | Blue/green cut-over with a named target port

> Server: `ssh ckad9988`

```bash
# 1. record the selector before touching anything
kubectl -n junction get svc junction -o json \
  | jq -r '.spec.selector | to_entries | sort_by(.key) | map("\(.key)=\(.value)") | join(",")' \
  > /home/candidate/exam/q7/old-selector.txt
cat /home/candidate/exam/q7/old-selector.txt        # app=junction,slot=blue,tier=web

# 2. why would green get no endpoints? targetPort is the NAME "http"
kubectl -n junction get svc junction -o jsonpath='{.spec.ports}'; echo
kubectl -n junction get deploy junction-blue junction-green \
  -o custom-columns=NAME:.metadata.name,REPLICAS:.spec.replicas,PORTS:.spec.template.spec.containers[0].ports
# junction-blue 4 [name:http] / junction-green 0 [name:web]  -> rename green's port
kubectl -n junction patch deploy junction-green --type=json \
  -p '[{"op":"replace","path":"/spec/template/spec/containers/0/ports/0/name","value":"http"}]'
kubectl -n junction scale deploy junction-green --replicas=4
kubectl -n junction rollout status deploy junction-green --timeout=120s

# 3. switch only the slot key (merge patch keeps app and tier)
kubectl -n junction patch svc junction -p '{"spec":{"selector":{"slot":"green"}}}'
kubectl -n junction get endpoints junction -o wide  # 4 green Pod IPs, port 80

# 4. drain blue, keep it for rollback
kubectl -n junction scale deploy junction-blue --replicas=0
```

A named `targetPort` is looked up in each selected Pod. Green names its port `web`, so without the rename the Service would have no endpoints at all. Patching only `slot` keeps `tier=web` in the selector, which keeps out the `junction-smoke` Pods (`slot=green`, `tier=smoke`) that `kubectl set selector app=junction,slot=green` would pull in.

---

## Question 8 | CreateContainerConfigError from missing ConfigMap keys

> Server: `ssh ckad9988`

```bash
kubectl -n lostproperty get pods                     # claims-desk-*  0/2  CreateContainerConfigError
kubectl -n lostproperty get pods -l app=claims-desk -o jsonpath='{range .items[0].status.containerStatuses[*]}{.name}{"\t"}{.state.waiting.reason}{"\t"}{.state.waiting.message}{"\n"}{end}'
# desk    CreateContainerConfigError  couldn't find key claim.window in ConfigMap lostproperty/desk-config
# ledger  CreateContainerConfigError  couldn't find key ledger.path in ConfigMap lostproperty/desk-config
echo CreateContainerConfigError > /home/candidate/exam/q8/reason.txt

grep -E '^(claim\.window|ledger\.path)=' /home/candidate/exam/q8/desk-settings.properties
kubectl -n lostproperty patch configmap desk-config --type=merge \
  -p '{"data":{"claim.window":"45d","ledger.path":"/var/ledger/claims.db"}}'

# no restart needed: the kubelet retries container creation on its own
kubectl -n lostproperty rollout status deployment/claims-desk --timeout=120s
kubectl -n lostproperty get pods -l app=claims-desk
```

Each container reports its own missing key, so both `desk` and `ledger` have to be checked. `notify.webhook` is missing too, but its `configMapKeyRef` is `optional: true`, so it does not block anything and must not be added. The kubelet keeps retrying the container start, and the Pods come up once the keys exist, with the Deployment untouched.

---

## Question 9 | Job forensics and an Indexed Job

> Server: `ssh ckad9988`

```bash
kubectl -n timetable get jobs
kubectl -n timetable get pods -l batch.kubernetes.io/job-name=timetable-import   # STATUS Init:Error
kubectl -n timetable get pods -l batch.kubernetes.io/job-name=timetable-import -o jsonpath='{range .items[*]}{.metadata.name}{"  init "}{.status.initContainerStatuses[0].name}{"="}{.status.initContainerStatuses[0].state.terminated.exitCode}{"\n"}{end}'
# verify-feed=23 (the main container "import" never started)
echo 23 > /home/candidate/exam/q9/exit-code.txt

cat <<'YAML' | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: timetable-build
  namespace: timetable
spec:
  completions: 6
  parallelism: 3
  completionMode: Indexed
  backoffLimit: 2
  activeDeadlineSeconds: 240
  ttlSecondsAfterFinished: 86400
  template:
    spec:
      restartPolicy: Never
      containers:
      - name: build
        image: busybox:1.36
        command: ["sh", "-c", "echo \"timetable shard $JOB_COMPLETION_INDEX built\""]
YAML
kubectl -n timetable wait --for=condition=Complete job/timetable-build --timeout=240s
for p in $(kubectl -n timetable get pods -l batch.kubernetes.io/job-name=timetable-build -o name); do kubectl -n timetable logs "$p"; done
```

The Pods failed in the init container (`Init:Error`), so the exit code is in `status.initContainerStatuses`. The `exit 64` in the main container's script is a decoy: that container never ran. Only `completionMode: Indexed` gives each Pod a completion index (`JOB_COMPLETION_INDEX` env var and the `batch.kubernetes.io/job-completion-index` annotation).

---

## Question 10 | Pull secrets via the ServiceAccount and a TLS Secret

> Server: `ssh ckad9988`

```bash
# single quotes: "$ignal" would otherwise be expanded by the shell
kubectl -n permits create secret docker-registry permits-registry \
  --docker-server=registry.permits.transit.local:5443 \
  --docker-username=permit-bot --docker-password='Gr33n$ignal-7'

kubectl -n permits get sa default -o jsonpath='{.imagePullSecrets}'; echo    # [{"name":"legacy-pull"}]
# append; a strategic/merge patch with a one-element list would REPLACE legacy-pull
kubectl -n permits patch serviceaccount default --type=json \
  -p '[{"op":"add","path":"/imagePullSecrets/-","value":{"name":"permits-registry"}}]'

cd /home/candidate/exam/q10/certs
for k in keys/*.key; do
  kubectl -n permits create secret tls x --cert=gate.crt --key="$k" --dry-run=client -o name >/dev/null 2>&1 && echo "match: $k"
done                                                   # match: keys/b7c2.key
kubectl -n permits create secret tls permits-tls --cert=gate.crt --key=keys/b7c2.key

# pull secrets are injected only at Pod creation -> re-create from a clean manifest
kubectl -n permits delete pod permit-check
kubectl -n permits run permit-check --image=registry.k8s.io/pause:3.9 --labels=app=permit-check
kubectl -n permits get pod permit-check -o jsonpath='{.spec.imagePullSecrets}'; echo
# [{"name":"legacy-pull"},{"name":"permits-registry"}]
```

The ServiceAccount admission plugin copies the SA's `imagePullSecrets` into a Pod only when the Pod is created and only when the Pod has none of its own. The running Pod therefore keeps its old list. A Pod re-created from `kubectl get pod -o yaml` also keeps the old list, because that dump still contains `imagePullSecrets: [legacy-pull]`. `ServiceAccount.imagePullSecrets` has no merge key, so the docs-style `kubectl patch sa default -p '{"imagePullSecrets":[...]}'` replaces the list instead of adding to it.

---

## Question 11 | Pending Pods: find the unsatisfiable request

> Server: `ssh ckad9988`

```bash
kubectl -n capacity get pods -o wide
kubectl -n capacity get events --field-selector reason=FailedScheduling
kubectl -n capacity describe pod -l app=load-planner | grep -A4 '^Events'
# 0/1 nodes are available: 1 Insufficient memory.   (load-reporter: Insufficient cpu, load-probe: node selector)
kubectl -n capacity get deploy load-planner -o jsonpath='{range .spec.template.spec.containers[*]}{.name}{"\t"}{.resources}{"\n"}{end}'
# cache requests memory 750Gi
echo cache:memory > /home/candidate/exam/q11/blocker.txt

kubectl -n capacity set resources deployment load-planner -c cache \
  --requests=cpu=50m,memory=96Mi --limits=cpu=100m,memory=128Mi
kubectl -n capacity rollout status deployment/load-planner --timeout=180s
```

The FailedScheduling event names the resource (`Insufficient memory`) but not the container, so the container has to be found in the Pod spec. The namespace events also show `Insufficient cpu` from the `load-reporter` decoy. Without `-c cache`, `kubectl set resources` rewrites every container, and the `planner` container would change too.

---

## Question 12 | Kustomize prod overlay: selectors and generator merge

> Server: `ssh ckad9988`

```bash
mkdir -p /home/candidate/exam/q12/overlays/prod
cat > /home/candidate/exam/q12/overlays/prod/kustomization.yaml <<'EOF2'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- ../../base
namespace: routes
namePrefix: prod-
labels:
- pairs:
    env: prod
  includeSelectors: true
replicas:
- name: route-board
  count: 3
images:
- name: nginx
  newTag: "1.26"
configMapGenerator:
- name: route-settings
  behavior: merge
  literals:
  - ROUTE_MODE=express
  - NIGHT_SERVICE=enabled
EOF2
kubectl kustomize /home/candidate/exam/q12/overlays/prod
kubectl apply -k /home/candidate/exam/q12/overlays/prod
kubectl -n routes rollout status deployment/prod-route-board --timeout=120s
kubectl -n routes get endpoints prod-route-board      # exactly 3 addresses
kubectl -n routes get cm -l env=prod -o yaml          # 4 keys, hash-suffixed name
```

`namePrefix` renames objects but does not change labels. A Service that still selects only `app=route-board` would also pick up the staging and legacy Pods, so `env=prod` has to go into the selectors (`labels` with `includeSelectors: true`, or `commonLabels`). With `behavior: merge` the overlay's literals are laid over the base generator's. `replace`, as used in the staging example, would drop `MAX_STOPS` and `FEED_URL`.

---

## Question 13 | Helm forensics: repair a failed release, upgrade keeping values

> Server: `ssh ckad9977`

```bash
helm -n helmyard ls -a                 # stop-indexer: failed (old-signage is only uninstalled)
helm -n helmyard ls --failed
helm -n helmyard history stop-indexer   # "context deadline exceeded"
kubectl -n helmyard get pods -l app.kubernetes.io/instance=stop-indexer   # ImagePullBackOff nginx:1.26.99
echo stop-indexer > /home/candidate/exam/q13/failed-release.txt

# a failed release can be upgraded in place; keep its values, change only the tag
helm -n helmyard get values stop-indexer
helm -n helmyard upgrade stop-indexer /home/candidate/exam/q13/depot-web-0.1.0.tgz \
  --reuse-values --set image.tag=1.26 --wait --timeout 120s

# --reuse-values would also reuse the OLD chart's defaults (and fails: .Values.board is nil)
helm -n helmyard get values route-planner -o yaml > /home/candidate/exam/q13/route-planner-values.yaml
helm -n helmyard upgrade route-planner /home/candidate/exam/q13/depot-web-0.2.0.tgz \
  -f /home/candidate/exam/q13/route-planner-values.yaml --wait --timeout 120s
# (equivalent: helm -n helmyard upgrade route-planner <0.2.0.tgz> --reset-then-reuse-values)

helm -n helmyard ls -a
helm -n helmyard get values route-planner
kubectl -n helmyard get deploy route-planner stop-indexer
kubectl -n helmyard get configmap route-planner-board -o yaml
```

`--reuse-values` merges the old user values over the *old* chart's values, so new defaults of 0.2.0 (the `board` block and the image tag) are lost and the template fails; passing the saved user values with `-f` (or `--reset-then-reuse-values`, or an upgrade without any value flags) keeps them while taking the new defaults. Upgrading a release whose only revision failed works in place and keeps its history, whereas `--set` without `--reuse-values` would drop its other user values.

---

## Question 14 | startupProbe for a slow-starting container

> Server: `ssh ckad9977`

```bash
kubectl -n sleepers get pods               # sleeper-berths and sleeper-linen both restart
kubectl -n sleepers describe pod -l app=sleeper-berths | grep -iE 'liveness|unhealthy|killing'
#   "Container warmer failed liveness probe, will be restarted"
kubectl -n sleepers describe pod -l app=sleeper-linen | grep -iE 'exit code|back-off'   # exits 3 (not a probe)
echo sleeper-berths > /home/candidate/exam/q14/deployment.txt

kubectl -n sleepers get deploy sleeper-berths -o yaml | grep -A8 livenessProbe   # GET / port http, period 5
# 60s / 5s = 12 failures; warmer is the SECOND container, patch it by name
kubectl -n sleepers patch deployment sleeper-berths -p '{"spec":{"template":{"spec":{"containers":[
  {"name":"warmer","startupProbe":{"httpGet":{"path":"/","port":"http"},"periodSeconds":5,"failureThreshold":12}}]}}}}'
kubectl -n sleepers rollout status deployment/sleeper-berths --timeout=180s
kubectl -n sleepers get pods -l app=sleeper-berths
```

While a startupProbe is defined, the kubelet runs neither the liveness nor the readiness probe until it succeeds, so the container gets `failureThreshold x periodSeconds` (12 x 5s = 60s) to come up without the aggressive liveness probe being touched. The probe must go on `warmer`, not on the first container `log-tail`; `sleeper-linen` also restarts, but because its process exits with code 3, not because of a probe.

---

## Question 15 | ConfigMap updates that reach running Pods (no subPath)

> Server: `ssh ckad9977`

```bash
kubectl -n fares get deploy fare-board -o yaml | grep -B2 -A3 subPath
kubectl -n fares get cm fare-table -o yaml                                   # PEAK 3.60 ...
kubectl -n fares exec deploy/fare-board -- cat /usr/share/nginx/html/fares/current.txt   # PEAK 3.10 (stale)

# one directory mount; items select and rename the keys (night.txt is not projected)
kubectl -n fares patch deployment fare-board --type=json -p '[
 {"op":"replace","path":"/spec/template/spec/volumes/0","value":{"name":"fares","configMap":{"name":"fare-table",
   "items":[{"key":"peak.txt","path":"current.txt"},{"key":"offpeak.txt","path":"offpeak.txt"}]}}},
 {"op":"replace","path":"/spec/template/spec/containers/0/volumeMounts","value":[
   {"name":"fares","mountPath":"/usr/share/nginx/html/fares"},
   {"name":"style","mountPath":"/usr/share/nginx/html/style"}]}]'
kubectl -n fares rollout status deployment/fare-board --timeout=120s
kubectl -n fares exec deploy/fare-board -- ls /usr/share/nginx/html/fares   # current.txt offpeak.txt

# only now change the data, then just wait
kubectl -n fares patch configmap fare-table --type=merge -p '{"data":{"peak.txt":"PEAK 3.95\n"}}'
sleep 90
kubectl -n fares exec deploy/fare-board -- cat /usr/share/nginx/html/fares/current.txt   # PEAK 3.95
```

A `subPath` mount binds one file of the volume at container start, so the kubelet's atomic symlink swap on a ConfigMap update never reaches it; a directory mount of the ConfigMap volume is refreshed in place. `items` both limits the directory to the listed keys and maps `peak.txt` to the file name `current.txt`; the check proves propagation by requiring the serving Pods to be older than the ConfigMap change.

---

## Question 16 | Pod Security Admission: make a Deployment restricted-compliant

> Server: `ssh ckad9977`

```bash
kubectl -n yardsafety get deploy,rs
kubectl -n yardsafety describe rs -l app=shunter | grep FailedCreate    # lists every violation
kubectl get ns yardsafety --show-labels

cat > /home/candidate/exam/q16/patch.json <<'EOF'
[
 {"op":"add","path":"/spec/template/spec/securityContext","value":
   {"runAsNonRoot":true,"runAsUser":1000,"runAsGroup":1000,"seccompProfile":{"type":"RuntimeDefault"}}},
 {"op":"add","path":"/spec/template/spec/initContainers/0/securityContext","value":
   {"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]}}},
 {"op":"replace","path":"/spec/template/spec/containers/0/securityContext","value":
   {"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]}}},
 {"op":"replace","path":"/spec/template/spec/volumes/0","value":{"name":"scratch","emptyDir":{}}}
]
EOF
kubectl -n yardsafety patch deployment shunter --type=json --patch-file /home/candidate/exam/q16/patch.json
kubectl -n yardsafety rollout status deployment/shunter --timeout=120s
kubectl -n yardsafety get pods -l app=shunter
```

Pod Security Admission rejects the Pods themselves (the ReplicaSet shows FailedCreate): every container, including the init container, needs `allowPrivilegeEscalation: false` and `drop: [ALL]` (so NET_ADMIN must go), and hostPath is not an allowed volume type. `runAsNonRoot: true` alone satisfies admission but busybox runs as UID 0 by default, so the kubelet then refuses to start it (CreateContainerConfigError) until a non-zero `runAsUser` is set - unlike the pause image in `yard-beacon`, which already runs as 65535.

---

## Question 17 | Custom resources with a clashing resource name

> Server: `ssh ckad9977`

```bash
kubectl api-resources | grep -w routes     # routes in freight.example.com AND transit.example.com
kubectl -n manifests get routes            # resolves to the freight group - wrong objects
kubectl explain routes.transit.example.com.spec
kubectl explain routes.transit.example.com.spec.serviceClass   # C1 = local, C5 = night network

cat <<'EOF' | kubectl apply -f -
apiVersion: transit.example.com/v1
kind: Route
metadata:
  name: f1-islands
  namespace: manifests
spec:
  line: F1
  mode: ferry
  stops: 6
  depot: pier-2
  serviceClass: C1
  frequencyMinutes: 30
---
apiVersion: transit.example.com/v1
kind: Route
metadata:
  name: n9-nightliner
  namespace: manifests
spec:
  line: N9
  mode: bus
  stops: 31
  depot: north
  serviceClass: C5
  frequencyMinutes: 20
EOF

kubectl -n manifests get routes.transit.example.com --sort-by=.spec.stops --no-headers \
  -o custom-columns=NAME:.metadata.name,LINE:.spec.line,CLASS:.spec.serviceClass,STOPS:.spec.stops \
  > /home/candidate/exam/q17/routes.txt
cat /home/candidate/exam/q17/routes.txt
```

When two API groups serve the same plural, the short name `routes` resolves to only one of them (here freight.example.com), so the transit objects must be addressed as `routes.transit.example.com` (or the `trt` short name) for `get` and `explain`. Field names such as `frequencyMinutes` and the class codes come only from the schema; strict field validation rejects guessed field names and the enum rejects wrong codes.

---

## Question 18 | NetworkPolicy: namespace AND pod selector

> Server: `ssh ckad9977`

```bash
kubectl get ns --show-labels | grep -E 'kiosk|ops-'
kubectl -n kiosk get pods --show-labels         # kiosk-cache also has tier=frontend
kubectl -n kiosk get netpol                      # legacy-frontend: tier=frontend, allow all
kubectl -n kiosk delete networkpolicy legacy-frontend   # policies add up, it would allow everything

cat <<'EOF' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: kiosk-ingress
  namespace: kiosk
spec:
  podSelector:
    matchLabels:
      app: kiosk
  policyTypes:
    - Ingress
  ingress:
    - from:
        - namespaceSelector:        # ONE peer: namespace team=ops AND pod role=monitor
            matchLabels:
              team: ops
          podSelector:
            matchLabels:
              role: monitor
        - podSelector: {}           # any Pod of namespace kiosk
      ports:
        - protocol: TCP
          port: 80
EOF

IP=$(kubectl -n kiosk get pod -l app=kiosk -o jsonpath='{.items[0].status.podIP}')
kubectl -n ops-east exec monitor -- wget -qO- -T 2 http://$IP          # allowed
kubectl -n ops-east exec guest   -- wget -qO- -T 2 http://$IP          # blocked
kubectl -n ops-west exec monitor -- wget -qO- -T 2 http://$IP          # blocked
kubectl -n kiosk exec kiosk-client -- wget -qO- -T 2 http://$IP        # allowed
kubectl -n kiosk exec kiosk-client -- wget -qO- -T 2 http://$IP:8081   # blocked
```

`namespaceSelector` and `podSelector` in the same `from` element are ANDed; as two separate list items they are ORed and would let every Pod of `ops-east` in. NetworkPolicies are additive, so the old allow-all policy on `tier=frontend` has to be removed (or narrowed) for the restriction to take effect, and putting both peers under one rule with `ports: 80` keeps 8081 closed for same-namespace clients too.
