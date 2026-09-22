# CKAD Multi-Cluster Exam B — Observatory: Answers

Each question runs on the server shown under its heading: `ssh` to that host and work with its default (and only) context — one cluster per host. Task files live under `/home/candidate/exam/q<N>/` on that server.

---

## Question 1 | Helm rollback and a second release from a values file

> Server: `ssh ckad9999`

```bash
# Revision 1 = working install, revision 2 = broken image tag
helm -n starmap history orrery-north
helm -n starmap rollback orrery-north 1
kubectl -n starmap rollout status deployment/orrery-north --timeout=120s

cat > /home/candidate/exam/q1/south-values.yaml <<'EOF'
replicaCount: 2
podAnnotations:
  site: south-ridge
EOF

helm -n starmap install orrery-south /home/candidate/exam/q1/orrery \
  -f /home/candidate/exam/q1/south-values.yaml
kubectl -n starmap rollout status deployment/orrery-south --timeout=120s
helm -n starmap list
helm -n starmap get values orrery-south
```

`helm rollback` restores the stored manifest and values of revision 1 as a new revision 3 ("Rollback to 1"), so the Deployment returns to `nginx:1.25`. Values passed with `-f` are stored as the release's user-supplied values, which `helm get values` shows.

---

## Question 2 | Zero-downtime rolling update with change-cause

> Server: `ssh ckad9999`

```bash
kubectl -n mirror patch deployment reflector --type=merge -p \
  '{"spec":{"strategy":{"type":"RollingUpdate","rollingUpdate":{"maxSurge":1,"maxUnavailable":0}}}}'

kubectl -n mirror set image deployment/reflector web=nginx:1.26
kubectl -n mirror annotate deployment reflector \
  kubernetes.io/change-cause="bump reflector to nginx 1.26" --overwrite

kubectl -n mirror rollout status deployment/reflector --timeout=180s
kubectl -n mirror rollout history deployment/reflector
kubectl -n mirror get deployment reflector -o wide
```

With `maxSurge: 1` / `maxUnavailable: 0` the controller adds one new Pod at a time and only removes an old Pod once a new one is ready. The Deployment already has a change-cause from its first release, so `--overwrite` is needed. The controller copies the annotation to the new ReplicaSet, which is where `rollout history` reads it.

---

## Question 3 | Egress NetworkPolicy with DNS

> Server: `ssh ckad9999`

```bash
cat <<'YAML' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: collector-egress
  namespace: relay
spec:
  podSelector:
    matchLabels:
      app: collector
  policyTypes:
    - Egress
  egress:
    - to:
        - podSelector:
            matchLabels:
              app: archive
      ports:
        - protocol: TCP
          port: 6379
    - ports:
        - protocol: UDP
          port: 53
        - protocol: TCP
          port: 53
YAML

# verify: archive reachable, everything else blocked
kubectl -n relay exec deploy/collector -- nc -z -w 3 archive 6379 && echo archive-ok
kubectl -n relay exec deploy/collector -- nc -z -w 3 webcache 80 || echo webcache-blocked
```

Once a Pod is selected by a policy with `Egress` in `policyTypes`, only the egress rules listed are allowed. DNS needs its own rule without a `to` (port 53 UDP+TCP), otherwise the Service name `archive` could not be resolved.

---

## Question 4 | Sorted and custom-column Pod listings

> Server: `ssh ckad9999`

```bash
cat > /home/candidate/exam/q4/oldest-first.sh <<'EOF'
kubectl get pods -n survey --sort-by=.metadata.creationTimestamp -o custom-columns=NAME:.metadata.name --no-headers
EOF

cat > /home/candidate/exam/q4/pod-ips.sh <<'EOF'
kubectl get pods -n survey -o custom-columns=NAME:.metadata.name,POD_IP:.status.podIP
EOF

bash /home/candidate/exam/q4/oldest-first.sh
bash /home/candidate/exam/q4/pod-ips.sh
```

`--sort-by` takes a JSONPath to a field and sorts ascending, so `.metadata.creationTimestamp` lists the oldest Pod first. `custom-columns=HEADER:jsonpath,...` sets both the column titles and their values, and `--no-headers` removes the header row. Both commands pass `-n survey` explicitly, so they do not depend on the current namespace.

---

## Question 5 | Native sidecar log shipper

> Server: `ssh ckad9999`

```bash
cat <<'YAML' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: prism
  namespace: spectra
spec:
  volumes:
    - name: logs
      emptyDir: {}
  initContainers:
    - name: log-tailer
      image: busybox:1.36
      restartPolicy: Always
      command: ["sh", "-c", "tail -F /var/log/prism/emission.log"]
      volumeMounts:
        - name: logs
          mountPath: /var/log/prism
  containers:
    - name: emitter
      image: busybox:1.36
      command: ["sh", "-c", "i=0; while true; do i=$((i+1)); echo \"spectral-line $i\" >> /var/log/prism/emission.log; sleep 2; done"]
      volumeMounts:
        - name: logs
          mountPath: /var/log/prism
YAML

kubectl -n spectra wait pod/prism --for=condition=Ready --timeout=90s
kubectl -n spectra logs prism -c log-tailer --tail=5
```

An init container with `restartPolicy: Always` is a native sidecar: it starts before the main container, keeps running alongside it for the life of the Pod, and does not block Pod completion. `tail -F` keeps retrying until the log file appears on the shared `emptyDir`, then streams every line to the sidecar's stdout.

---

## Question 6 | ConfigMap from env-file, envFrom and selector cleanup

> Server: `ssh ckad9999`

```bash
kubectl -n almanac create configmap sky-settings --from-env-file=/home/candidate/exam/q6/almanac.env

cat <<'YAML' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: almanac-reader
  namespace: almanac
spec:
  containers:
    - name: reader
      image: busybox:1.36
      command: ["sleep", "3600"]
      envFrom:
        - configMapRef:
            name: sky-settings
YAML

kubectl -n almanac get configmap -l stale=true
kubectl -n almanac delete configmap -l stale=true

kubectl -n almanac wait pod/almanac-reader --for=condition=Ready --timeout=60s
kubectl -n almanac exec almanac-reader -- env | grep -E 'SUNRISE|TIDE|MOON|FORECAST'
```

`--from-env-file` turns each `KEY=value` line into its own key and skips comments and blank lines. `--from-file` would instead store the whole file under one key. `envFrom.configMapRef` injects every key as an env var, and `-l stale=true` matches only that exact label value, so `stale=false` and unlabelled ConfigMaps are kept.

---

## Question 7 | Secret with items, defaultMode and an optional key

> Server: `ssh ckad9988`

```bash
cd /home/candidate/exam/q7
kubectl -n vault create secret generic observatory-tls \
  --from-file=signing.key --from-file=ca.crt

cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: cert-loader
  namespace: vault
spec:
  containers:
    - name: loader
      image: busybox:1.36
      command: ["sh", "-c", "sleep 3600"]
      env:
        - name: ROTATION_TOKEN
          valueFrom:
            secretKeyRef:
              name: observatory-tls
              key: rotation.token
              optional: true
      volumeMounts:
        - name: tls
          mountPath: /etc/observatory
          readOnly: true
  volumes:
    - name: tls
      secret:
        secretName: observatory-tls
        defaultMode: 0400
        items:
          - key: signing.key
            path: keys/private.pem
EOF

kubectl -n vault wait pod/cert-loader --for=condition=Ready --timeout=60s
kubectl -n vault exec cert-loader -- ls -R /etc/observatory
kubectl -n vault exec cert-loader -- stat -L -c %a /etc/observatory/keys/private.pem   # 400
```

`items` makes the Secret volume project only the listed keys, each under its own relative `path`, so `ca.crt` never shows up in the mount. YAML reads `0400` as octal, so the API stores it as `256`. `optional: true` on the `secretKeyRef` lets the container start with the env var left unset while the key is missing, instead of failing with `CreateContainerConfigError`.

---

## Question 8 | Fix a broken readiness probe

> Server: `ssh ckad9988`

```bash
# inspect: the probe hits /healthz on 8080, but nginx listens on 80 and has no /healthz
kubectl -n dome get deployment skyview -o jsonpath='{.spec.template.spec.containers[0].readinessProbe}{"\n"}'

kubectl -n dome patch deployment skyview --type=json -p='[
  {"op":"replace","path":"/spec/template/spec/containers/0/readinessProbe/httpGet/path","value":"/"},
  {"op":"replace","path":"/spec/template/spec/containers/0/readinessProbe/httpGet/port","value":80}
]'

kubectl -n dome rollout status deployment/skyview --timeout=120s
kubectl -n dome get deployment skyview
```

The probe was failing on both counts: port 8080 refuses the connection and `/healthz` returns 404. A JSON patch (or `kubectl edit`) changes only the two broken fields and leaves the timings and the liveness probe alone. Because it edits the pod template, the Deployment rolls out new Pods, and they turn Ready once `GET /` on port 80 returns 200.

---

## Question 9 | NodePort Service with a named targetPort

> Server: `ssh ckad9988`

```bash
# the container port is named rx-http, the Service asks for "http"
kubectl -n antenna get deployment dish-receiver \
  -o jsonpath='{range .spec.template.spec.containers[*].ports[*]}{.name}={.containerPort}{"\n"}{end}'
kubectl -n antenna get service dish-receiver -o jsonpath='{.spec.ports}{"\n"}'

kubectl -n antenna patch service dish-receiver --type=json -p='[
  {"op":"replace","path":"/spec/ports/0/targetPort","value":"rx-http"},
  {"op":"replace","path":"/spec/ports/0/nodePort","value":30725}
]'

kubectl -n antenna get endpoints dish-receiver   # two pod IPs on port 80
kubectl -n antenna get service dish-receiver     # 8080:30725/TCP
```

A string `targetPort` is resolved against the `name` of each selected Pod's container ports. If no container port has that name, the Pod is left out of the Endpoints, so the Service has none. Pointing `targetPort` at `rx-http` fixes routing without touching the Deployment, and the `nodePort` of a NodePort Service can be changed in place to any free port in 30000-32767.

---

## Question 10 | Relabel, annotate and query annotations

> Server: `ssh ckad9988`

```bash
kubectl -n catalog get pods --show-labels

kubectl -n catalog label pods -l tier=ingest tier=stream --overwrite
kubectl -n catalog annotate pods -l survey=wide 'catalog.observatory.io/retention=hot=7d,cold=365d'

kubectl -n catalog get pods -o json \
  | jq -r '.items[] | select(.metadata.annotations["catalog.observatory.io/legacy-schema"] != null) | .metadata.name' \
  | sort > /home/candidate/exam/q10/legacy-schema-pods.txt
cat /home/candidate/exam/q10/legacy-schema-pods.txt   # idx-andromeda, idx-draco, idx-eridanus
```

Changing an existing label needs `--overwrite`, and both `label` and `annotate` take `-l`, so one command covers every matching Pod. kubectl splits an annotation argument at the first `=`, so the value can itself contain `=` and `,`. Label selectors can't match annotations, so the file is built by testing the exact key with jq; a `grep legacy-schema` would also pick up `idx-bootes`, which has `catalog.observatory.io/legacy-schema-migrated`.

---

## Question 11 | Migrate a PDB to policy/v1 and add a memory HPA

> Server: `ssh ckad9988`

```bash
# as shipped, applying the file fails: no matches for kind "PodDisruptionBudget" in version "policy/v1beta1"
sed -i 's#^apiVersion: policy/v1beta1#apiVersion: policy/v1#' /home/candidate/exam/q11/satpos-pdb.yaml
kubectl apply -f /home/candidate/exam/q11/satpos-pdb.yaml
kubectl -n tracker get pdb satpos-pdb

cat <<'EOF' | kubectl apply -f -
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: satpos-hpa
  namespace: tracker
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: satpos
  minReplicas: 2
  maxReplicas: 6
  metrics:
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: 75
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 180
EOF
kubectl -n tracker get hpa satpos-hpa
```

`policy/v1beta1` PodDisruptionBudgets were removed in v1.25. The `policy/v1` spec is the same apart from how an empty selector behaves, so changing `apiVersion` is enough here. `kubectl autoscale` can only create CPU targets, so a memory target and `behavior` need an `autoscaling/v2` manifest; memory utilization is measured against the containers' memory requests.

---

## Question 12 | Promote a canary with Kustomize images

> Server: `ssh ckad9988`

```bash
cd /home/candidate/exam/q12/telemetry
cat >> kustomization.yaml <<'EOF'
images:
  - name: nginx
    newTag: "1.26"
EOF

kubectl kustomize . | grep 'image:'          # image: nginx:1.26
kubectl apply -k .
kubectl -n orbit rollout status deployment/telemetry --timeout=120s

kubectl -n orbit delete deployment telemetry-canary
kubectl -n orbit get endpoints telemetry     # 3 addresses, all stable pods
```

The kustomize `images` transformer rewrites every container image named `nginx` when the manifests are rendered, so `deployment.yaml` keeps `nginx:1.25` while the applied Deployment runs `nginx:1.26`. Quote the tag so YAML keeps `1.26` a string rather than a number. Once the stable Deployment is fully rolled out on the new image, deleting the canary leaves the Service selecting only the 3 stable Pods.

---

## Question 13 | Headless Service DNS and previous container logs

> Server: `ssh ckad9977`

```bash
# 1. Headless Service (clusterIP: None) for the watchtower pods
cat <<'YAML' | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: watchtower-peers
  namespace: nightwatch
spec:
  clusterIP: None
  selector:
    app: watchtower
  ports:
    - port: 80
      targetPort: 80
YAML
kubectl -n nightwatch get endpoints watchtower-peers
sleep 3

# 2. Resolve the Service name from a throw-away busybox pod
kubectl -n nightwatch run dns-probe --image=busybox:1.36 --restart=Never --rm -i --quiet -- \
  nslookup watchtower-peers.nightwatch.svc.cluster.local > /home/candidate/exam/q13/dns.txt
cat /home/candidate/exam/q13/dns.txt
kubectl -n nightwatch get pods -l app=watchtower -o wide   # every pod IP must appear in dns.txt

# 3. Logs of the crashed (previous) container instance only
kubectl -n nightwatch get pod insomniac                    # RESTARTS >= 1
kubectl -n nightwatch logs insomniac --previous > /home/candidate/exam/q13/crash.log
cat /home/candidate/exam/q13/crash.log
```

A headless Service has no virtual IP, so its DNS name resolves straight to one A record per ready Pod instead of a single ClusterIP. `kubectl logs --previous` (`-p`) reads the last terminated instance of the container. That is where the crash message is, because the current instance only logs that it restarted.

---

## Question 14 | Immutable ConfigMap swap with a checksum annotation

> Server: `ssh ckad9977`

```bash
# 1. New immutable ConfigMap (kubectl create has no --immutable flag, so use YAML)
cat <<'YAML' | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: optics-v2
  namespace: calibration
immutable: true
data:
  FOCAL_LENGTH: "2400"
  APERTURE: "f11"
  FILTER: "h-alpha"
YAML

# 2 + 3. Point the "optics" volume at optics-v2 and annotate the pod template in one patch
kubectl -n calibration patch deployment lens-calibrator -p '{"spec":{"template":{"metadata":{"annotations":{"observatory.io/optics-checksum":"9f2c41ab"}},"spec":{"volumes":[{"name":"optics","configMap":{"name":"optics-v2"}}]}}}}'

# 4. Wait for the new pods and verify
kubectl -n calibration rollout status deployment lens-calibrator --timeout=120s
kubectl -n calibration get pods -l app=lens-calibrator
kubectl -n calibration exec deploy/lens-calibrator -- cat /etc/lens/FILTER
```

Nobody can edit an immutable ConfigMap, so to change config you create a new, versioned ConfigMap and point the workload at it. Changing the pod template (the volume reference plus the checksum annotation) starts a rolling update, and the new pods mount the new data.

---

## Question 15 | Dynamic PVC surviving pod replacement

> Server: `ssh ckad9977`

```bash
cat <<'YAML' | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: plate-archive
  namespace: archive
spec:
  storageClassName: local-path
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 100Mi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: plate-scanner
  namespace: archive
spec:
  replicas: 1
  selector:
    matchLabels:
      app: plate-scanner
  template:
    metadata:
      labels:
        app: plate-scanner
    spec:
      containers:
        - name: scanner
          image: busybox:1.36
          command: ["sh", "-c", "echo scanned-by $(hostname) >> /archive/scans.log; sleep 86400"]
          volumeMounts:
            - name: plates
              mountPath: /archive
      volumes:
        - name: plates
          persistentVolumeClaim:
            claimName: plate-archive
YAML
kubectl -n archive rollout status deployment plate-scanner --timeout=120s
kubectl -n archive get pvc plate-archive          # Bound, STORAGECLASS local-path

# Replace the pod; the new one must still see the first pod's line
kubectl -n archive delete pod -l app=plate-scanner   # waits until the old pod is gone
kubectl -n archive rollout status deployment plate-scanner --timeout=120s
kubectl -n archive exec deploy/plate-scanner -- cat /archive/scans.log   # two scanned-by lines
```

The `local-path` StorageClass uses `WaitForFirstConsumer`, so the PVC stays Pending until the first pod is scheduled, and then a volume is provisioned for it. The data belongs to the PV and not to the pod. The replacement pod mounts the same claim and still has the first pod's line, with its own line added after it.

---

## Question 16 | Suspended, hardened CronJob

> Server: `ssh ckad9977`

```bash
cat <<'YAML' | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: star-catalog-sync
  namespace: nightly
spec:
  schedule: "15 3 * * *"
  concurrencyPolicy: Forbid
  startingDeadlineSeconds: 200
  suspend: true
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
            - name: sync
              image: busybox:1.36
              command: ["sh", "-c", "echo catalog synced"]
              securityContext:
                allowPrivilegeEscalation: false
                capabilities:
                  drop: ["ALL"]
                seccompProfile:
                  type: RuntimeDefault
YAML
kubectl -n nightly get cronjob star-catalog-sync   # SUSPEND = True, no jobs created
```

`suspend: true` in the manifest means the controller never schedules a Job until someone sets it to false. `concurrencyPolicy: Forbid` skips a run while the previous one is still going, and `startingDeadlineSeconds` drops a missed run once it is more than 200s late. The security settings go in the container's own `securityContext`, inside `jobTemplate.spec.template.spec.containers`.

---

## Question 17 | Quota-blocked Deployment fixed with LimitRange defaults

> Server: `ssh ckad9977`

```bash
# Diagnose: the ReplicaSet cannot create pods because the quota demands requests/limits
kubectl -n spectro get deployment prism                  # READY 0/3
kubectl -n spectro describe resourcequota spectro-budget
kubectl -n spectro get events --field-selector reason=FailedCreate | tail -n 3
#   ... forbidden: failed quota: spectro-budget: must specify limits.cpu for: analyzer; ...

# Fix: namespace-wide container defaults (quota and Deployment manifest stay untouched)
cat <<'YAML' | kubectl apply -f -
apiVersion: v1
kind: LimitRange
metadata:
  name: spectro-defaults
  namespace: spectro
spec:
  limits:
    - type: Container
      default:
        cpu: 100m
        memory: 128Mi
      defaultRequest:
        cpu: 50m
        memory: 64Mi
YAML

# Recreate the pods now (the ReplicaSet may otherwise still be in its retry back-off)
kubectl -n spectro rollout restart deployment prism
kubectl -n spectro rollout status deployment prism --timeout=120s
kubectl -n spectro get pods -l app=prism -o jsonpath='{range .items[*]}{.metadata.name}{"  "}{.spec.containers[0].resources}{"\n"}{end}'
kubectl -n spectro describe resourcequota spectro-budget   # used: 150m/192Mi requests, 300m/384Mi limits
```

A ResourceQuota that covers `requests.*`/`limits.*` rejects any pod whose containers leave those values unset. The LimitRanger admission plugin fills in the LimitRange defaults before the quota is checked, so the three pods (limits 300m/384Mi and requests 150m/192Mi in total) are admitted without editing the quota or the Deployment manifest.
