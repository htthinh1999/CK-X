# CKAD Multi-Cluster Exam A — Harbor Logistics: Answers

Each question runs on the server shown under its heading: `ssh` to that host and work with its default (and only) context — one cluster per host. Task files live under `/home/candidate/exam/q<N>/` on that server.

---

## Question 1 | Roll back a broken Deployment

> Server: `ssh ckad9999`

```bash
kubectl -n quayside rollout history deployment crane
kubectl -n quayside rollout history deployment crane --revision=2   # nginx:1.25 + LIFT_MODE=tandem (last good one)
kubectl -n quayside rollout undo deployment crane --to-revision=2
kubectl -n quayside rollout status deployment crane --timeout=120s
kubectl -n quayside get deployment crane \
  -o jsonpath='{.metadata.annotations.deployment\.kubernetes\.io/revision}' > /home/candidate/exam/q1/revision.txt
cat /home/candidate/exam/q1/revision.txt   # 4
```

A rollback copies the pod template of revision 2 back into the Deployment and records it as a **new** revision (4); revision 2 disappears from the history, so the file must contain `4`, not `2`. Revision 1 also ran `nginx:1.25` but without `LIFT_MODE=tandem`, so it is not the last working revision.

---

## Question 2 | Pod with env and a jsonpath status command

> Server: `ssh ckad9999`

```bash
kubectl -n beacon run lamp-keeper --image=busybox:1.36 --labels=tier=signal \
  --env=BEAM_COLOR=amber --command -- sh -c 'while true; do echo "beam=$BEAM_COLOR"; sleep 5; done'
kubectl -n beacon wait pod lamp-keeper --for=condition=Ready --timeout=60s

echo "kubectl get pod lamp-keeper -n beacon -o jsonpath='{.status.phase}'" > /home/candidate/exam/q2/phase.sh
bash /home/candidate/exam/q2/phase.sh; echo     # Running
kubectl -n beacon logs lamp-keeper --tail=2     # beam=amber
```

The single quotes stop your own shell from expanding `$BEAM_COLOR`, so the container's shell expands it at runtime. The status command names both the pod and the namespace, so it works from any namespace and ignores the other `tier=signal` pod (which has phase `Succeeded`).

---

## Question 3 | Kustomize canary overlay

> Server: `ssh ckad9999`

```bash
mkdir -p /home/candidate/exam/q3/overlays/canary
cat > /home/candidate/exam/q3/overlays/canary/kustomization.yaml <<'EOF'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ../../base
nameSuffix: -canary
labels:
  - pairs:
      track: canary
    includeSelectors: true
replicas:
  - name: weighbridge
    count: 1
images:
  - name: nginx
    newTag: "1.26"
patches:
  - patch: |-
      $patch: delete
      apiVersion: v1
      kind: Service
      metadata:
        name: weighbridge
EOF
kubectl kustomize /home/candidate/exam/q3/overlays/canary      # only Deployment weighbridge-canary
kubectl apply -k /home/candidate/exam/q3/base
kubectl apply -k /home/candidate/exam/q3/overlays/canary
kubectl -n tally rollout status deployment weighbridge --timeout=120s
kubectl -n tally rollout status deployment weighbridge-canary --timeout=120s
kubectl -n tally get endpoints weighbridge                     # 4 addresses
```

The overlay reuses the base, renames it with `nameSuffix`, and drops the base Service with a `$patch: delete` patch so only the canary Deployment is rendered. Its pods keep `app: weighbridge` (plus `track: canary`), so the single base Service balances over 3 stable + 1 canary pods.

---

## Question 4 | Manage Helm releases

> Server: `ssh ckad9999`

```bash
helm -n berth list
helm -n berth get values tugboat            # podAnnotations.owner=berth-ops must be kept

helm -n berth upgrade tugboat /home/candidate/exam/q4/dockyard --reuse-values \
  --set replicaCount=2 --set podAnnotations.crew=night-shift

helm -n berth uninstall pilot-legacy

helm -n berth install harbormaster /home/candidate/exam/q4/dockyard --set service.type=NodePort

helm -n berth list
helm -n berth get values tugboat
kubectl -n berth get deploy,svc
```

Without `--reuse-values`, `helm upgrade` starts again from the chart defaults and the existing `owner` annotation would be lost. `helm uninstall` removes the release together with all its resources.

---

## Question 5 | Fix a misconfigured Service

> Server: `ssh ckad9999`

```bash
kubectl -n manifest get pods --show-labels                   # app=manifest-api, tier=backend
kubectl -n manifest get svc manifest-api -o yaml             # selector app=manifest-app, targetPort 8081
kubectl -n manifest get deploy manifest-api -o jsonpath='{.spec.template.spec.containers[0].ports}'; echo   # http / 80

kubectl -n manifest patch service manifest-api --type=json -p='[
  {"op": "replace", "path": "/spec/selector", "value": {"app": "manifest-api", "tier": "backend"}},
  {"op": "replace", "path": "/spec/ports/0/targetPort", "value": 80}
]'
kubectl -n manifest get endpoints manifest-api               # 2 pod IPs on port 80
```

A Service only gets endpoints when its selector matches the pod labels, and `targetPort` must be the port the container really listens on (`80`, or its name `http`). Both are fixed on the Service, so the Deployment stays untouched.

---

## Question 6 | Exec readiness probe

> Server: `ssh ckad9999`

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: boom-gate
  namespace: gatehouse
spec:
  replicas: 3
  selector:
    matchLabels:
      app: boom-gate
  template:
    metadata:
      labels:
        app: boom-gate
    spec:
      containers:
        - name: controller
          image: busybox:1.36
          command: ["sh", "-c", "sleep 15; touch /tmp/gate-open; while true; do sleep 3600; done"]
          readinessProbe:
            exec:
              command: ["cat", "/tmp/gate-open"]
            initialDelaySeconds: 5
            periodSeconds: 5
EOF
kubectl -n gatehouse rollout status deployment boom-gate --timeout=120s
kubectl -n gatehouse get pods -l app=boom-gate
```

The exec probe fails (non-zero exit) until the container creates `/tmp/gate-open` after ~15 s, so the pods stay `0/1` and out of Service endpoints until then; afterwards every probe succeeds and all 3 replicas become ready.

---

## Question 7 | ConfigMap from file + label selector

> Server: `ssh ckad9988`

```bash
kubectl -n tides create configmap gauge-config \
  --from-file=station.conf=/home/candidate/exam/q7/gauge.properties
kubectl -n tides label configmap gauge-config tier=gauge region=west

kubectl -n tides get configmaps -l 'tier=gauge,status!=retired' -o name \
  | cut -d/ -f2 | sort > /home/candidate/exam/q7/active-gauges.txt
cat /home/candidate/exam/q7/active-gauges.txt
# gauge-config
# tide-mouth
# tide-north
# tide-south
```

`--from-file=<key>=<path>` stores the file under a key you choose instead of the file name. The `!=` selector also matches objects that do not have the `status` label at all, so `gauge-config` and `tide-north` are included, and only `tide-east` (`status=retired`) is left out.

---

## Question 8 | Secret as volume and env var

> Server: `ssh ckad9988`

```bash
kubectl -n customs create secret generic broker-creds \
  --from-literal=api-token=tk-7731-harbor \
  --from-literal=broker-id=HL-0042

cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: declarations
  namespace: customs
spec:
  volumes:
    - name: creds
      secret:
        secretName: broker-creds
  containers:
    - name: clerk
      image: nginx:1.25
      env:
        - name: CUSTOMS_BROKER_ID
          valueFrom:
            secretKeyRef:
              name: broker-creds
              key: broker-id
      volumeMounts:
        - name: creds
          mountPath: /etc/customs/creds
          readOnly: true
EOF
kubectl -n customs wait pod/declarations --for=condition=Ready --timeout=120s
kubectl -n customs exec declarations -c clerk -- ls /etc/customs/creds
kubectl -n customs exec declarations -c clerk -- printenv CUSTOMS_BROKER_ID
```

A `secret` volume with no `items` list turns every key into a file in the mount directory. `readOnly: true` goes on the container's `volumeMounts` entry. `secretKeyRef` copies a single key into an environment variable.

---

## Question 9 | CronJob with non-root securityContext

> Server: `ssh ckad9988`

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: reconcile
  namespace: ledger
spec:
  schedule: "15 2 * * *"
  successfulJobsHistoryLimit: 5
  failedJobsHistoryLimit: 2
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: Never
          securityContext:
            runAsUser: 2500
            runAsNonRoot: true
          containers:
            - name: reconciler
              image: busybox:1.36
              command: ["sh", "-c", "echo ledger-ok uid=$(id -u)"]
              securityContext:
                readOnlyRootFilesystem: true
EOF

kubectl -n ledger create job reconcile-manual-01 --from=cronjob/reconcile
kubectl -n ledger wait job/reconcile-manual-01 --for=condition=Complete --timeout=120s
kubectl -n ledger logs job/reconcile-manual-01   # ledger-ok uid=2500
```

`runAsUser` and `runAsNonRoot` can be set for the whole Pod, but `readOnlyRootFilesystem` exists only in a container's `securityContext`. `kubectl create job --from=cronjob/<name>` copies the CronJob's job template and sets the CronJob as the Job's owner.

---

## Question 10 | HPA manifest migration to autoscaling/v2

> Server: `ssh ckad9988`

```bash
# applying the original file fails: no matches for kind "HorizontalPodAutoscaler" in version "autoscaling/v2beta2"
kubectl api-versions | grep autoscaling   # autoscaling/v1, autoscaling/v2

cat > /home/candidate/exam/q10/forklift-hpa.yaml <<'EOF'
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: forklift-hpa
  namespace: yard
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: forklift
  minReplicas: 2
  maxReplicas: 5
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 60
EOF
kubectl apply -f /home/candidate/exam/q10/forklift-hpa.yaml
kubectl -n yard wait deployment/forklift --for=jsonpath='{.status.readyReplicas}'=2 --timeout=120s
kubectl -n yard get hpa forklift-hpa
```

`autoscaling/v2beta2` was removed in Kubernetes 1.26. Its schema matches `autoscaling/v2`, so changing the `apiVersion` is enough to convert it, and then you update the values. The HPA brings the Deployment up to `minReplicas` straight away, even before it has any CPU metrics.

---

## Question 11 | Logging sidecar for a file-based app

> Server: `ssh ckad9988`

```bash
kubectl -n winch patch deployment hoist-controller --type=strategic -p '
spec:
  template:
    spec:
      containers:
        - name: log-tail
          image: busybox:1.36
          command: ["sh", "-c", "tail -n +1 -F /var/log/hoist/cycles.log"]
          volumeMounts:
            - name: hoist-logs
              mountPath: /var/log/hoist
'
kubectl -n winch rollout status deployment/hoist-controller --timeout=120s
sleep 10   # let the old pod finish terminating
kubectl -n winch logs deployment/hoist-controller -c log-tail --tail=5
```

A strategic merge patch merges `containers` by `name`, so the new `log-tail` entry is added next to `hoist` and `hoist` is left alone. You can also add the same container block to `/home/candidate/exam/q11/hoist-controller.yaml` and `kubectl apply` it. The sidecar reads the shared `emptyDir` and writes the lines to its own stdout, where `kubectl logs -c log-tail` can see them.

---

## Question 12 | Bulk labels and annotations with selectors

> Server: `ssh ckad9988`

```bash
kubectl -n dockhands get pods --show-labels

kubectl -n dockhands label pods -l role=stevedore shift=night
kubectl -n dockhands annotate pods -l role=lasher safety.example.com/certified=rigging-l2 --overwrite
kubectl -n dockhands label pods -l onboarding onboarding-

kubectl -n dockhands get pods -L role,shift,onboarding
kubectl -n dockhands get pods -o json \
  | jq -r '.items[] | "\(.metadata.name) \(.metadata.annotations["safety.example.com/certified"] // "-")"'
```

`-l` applies one change to every Pod that matches. `lasher-2` already has the annotation, so without `--overwrite` kubectl refuses to change it. A trailing `-` (`onboarding-`) removes the key, and the bare selector `-l onboarding` matches every Pod that has that key.

---

## Question 13 | ClusterIP Service smoke test and Pod logs

> Server: `ssh ckad9977`

```bash
kubectl -n signal run foghorn --image=nginx:1.25 --labels=app=foghorn --port=80
kubectl -n signal expose pod foghorn --name=foghorn-svc --type=ClusterIP --port=8080 --target-port=80
kubectl -n signal wait --for=condition=Ready pod/foghorn --timeout=90s
kubectl -n signal get endpoints foghorn-svc

mkdir -p /home/candidate/exam/q13
kubectl -n signal run fetch --image=busybox:1.36 --restart=Never --rm -i \
  -- wget -qO- http://foghorn-svc:8080/ > /home/candidate/exam/q13/response.html
kubectl -n signal logs foghorn > /home/candidate/exam/q13/foghorn.log
grep -i 'welcome to nginx' /home/candidate/exam/q13/response.html
grep 'GET /' /home/candidate/exam/q13/foghorn.log
```

`kubectl expose` copies the Pod's labels into the Service selector, and `--port`/`--target-port` map Service port 8080 to container port 80. `kubectl run --rm -i --restart=Never` attaches to the one-shot busybox Pod, streams its stdout into the local file and deletes the Pod afterwards. Because nginx writes its access log to stdout, the `wget` request then shows up as a `GET /` line in `kubectl logs`.

---

## Question 14 | ConfigMap change, rollout restart and annotation

> Server: `ssh ckad9977`

```bash
kubectl -n lighthouse patch configmap lamp-config --type merge -p '{"data":{"rotation":"fast"}}'
kubectl -n lighthouse annotate configmap lamp-config harbor-logistics.io/change-ticket=HL-4471 --overwrite
kubectl -n lighthouse rollout restart deployment lamp-driver
kubectl -n lighthouse rollout status deployment lamp-driver --timeout=120s
kubectl -n lighthouse exec deploy/lamp-driver -- printenv LAMP_ROTATION
```

Environment variables from `configMapKeyRef` are resolved only when a container starts, so editing the ConfigMap does not change running Pods. `kubectl rollout restart` bumps a pod-template annotation, and the Deployment replaces every Pod with one that reads the new value. The annotation goes on the ConfigMap object itself, not on the Deployment.

---

## Question 15 | Static hostPath PersistentVolume and claim

> Server: `ssh ckad9977`

```bash
cat <<'YAML' | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: ledger-pv
spec:
  capacity:
    storage: 200Mi
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  hostPath:
    path: /tmp/cargo-ledger
    type: DirectoryOrCreate
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ledger-claim
  namespace: cargo
spec:
  storageClassName: manual
  volumeName: ledger-pv
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 200Mi
---
apiVersion: v1
kind: Pod
metadata:
  name: ledger-writer
  namespace: cargo
spec:
  volumes:
    - name: ledger
      persistentVolumeClaim:
        claimName: ledger-claim
  containers:
    - name: writer
      image: busybox:1.36
      command: ["sh", "-c", "echo 'manifest=sealed' > /ledger/entry.txt && sleep 86400"]
      volumeMounts:
        - name: ledger
          mountPath: /ledger
YAML
kubectl -n cargo get pvc ledger-claim
kubectl -n cargo wait --for=condition=Ready pod/ledger-writer --timeout=90s
kubectl -n cargo exec ledger-writer -- cat /ledger/entry.txt
```

Setting `storageClassName: manual` on both objects stops the default `local-path` StorageClass from provisioning a volume dynamically. The claim is then matched statically, and `volumeName: ledger-pv` pins it to that exact PV. The PV is cluster-scoped while the PVC and the Pod live in `cargo`, and the Pod only refers to the claim.

---

## Question 16 | NetworkPolicy: database reachable only from the backend

> Server: `ssh ckad9977`

```bash
kubectl -n pier get pods --show-labels
cat <<'YAML' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: berth-db-access
  namespace: pier
spec:
  podSelector:
    matchLabels:
      tier: db
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              tier: backend
      ports:
        - protocol: TCP
          port: 6379
YAML
kubectl -n pier describe networkpolicy berth-db-access
```

Once a Pod is selected by a policy with `policyTypes: [Ingress]`, all inbound traffic to it is denied except what the rules allow, while its egress stays unrestricted because `Egress` is not listed. A `from` peer that has only a `podSelector` (no `namespaceSelector`) matches Pods in the policy's own namespace. Putting `from` and `ports` in the same rule means both must match, so only `tier=backend` Pods can connect, and only on TCP 6379.

---

## Question 17 | LimitRange defaults and ResourceQuota

> Server: `ssh ckad9977`

```bash
cat <<'YAML' | kubectl apply -f -
apiVersion: v1
kind: LimitRange
metadata:
  name: crate-defaults
  namespace: wharf
spec:
  limits:
    - type: Container
      defaultRequest:
        cpu: 50m
        memory: 64Mi
      default:
        cpu: 100m
        memory: 128Mi
YAML
kubectl -n wharf create quota wharf-quota --hard=pods=4,requests.cpu=400m,limits.memory=512Mi
kubectl -n wharf run forklift --image=nginx:1.25
kubectl -n wharf wait --for=condition=Ready pod/forklift --timeout=90s
kubectl -n wharf get pod forklift -o jsonpath='{.spec.containers[0].resources}'; echo
kubectl -n wharf describe resourcequota wharf-quota
```

In a LimitRange, `defaultRequest` sets the default requests and `default` sets the default limits. The LimitRanger admission plugin fills them into any container that leaves them out and records this in the Pod's `kubernetes.io/limit-ranger` annotation. A quota on `requests.cpu` and `limits.memory` rejects Pods that don't declare those values, so the LimitRange must exist first; then the Pod without resources is admitted and counted against `wharf-quota`.
