# CKAD Simulation 20 — Answers

> Dojo Musashi 🏆 — *「武蔵は二刀を極める」- Musashi masters the two swords*
>
> All paths use `/tmp/exam/course/N/...`. Each question runs on the server shown under its heading: `ssh` to that host and use its default context (one cluster per host). A throwaway local registry on `localhost:5000` is started by the setup for questions that push images.

---

## Question 1 | LimitRange and ResourceQuota

> Server: `ssh ckad9977`

```bash
mkdir -p /tmp/exam/course/1
cat <<EOF > /tmp/exam/course/1/quota.yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: cpu-limits
  namespace: crown
spec:
  limits:
  - type: Container
    default:
      cpu: 500m
    defaultRequest:
      cpu: 200m
---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: crown
spec:
  hard:
    pods: "4"
    requests.cpu: "2"
    limits.cpu: "2"
    requests.memory: 4Gi
    limits.memory: 4Gi
EOF
kubectl apply -f /tmp/exam/course/1/quota.yaml
```

LimitRange sets CPU default 500m / request 200m; ResourceQuota caps 4 pods, 2 CPU, 4Gi memory.

---

## Question 2 | Kustomize overlay

> Server: `ssh ckad9988`

```bash
mkdir -p /tmp/exam/course/2/prod
cat <<EOF > /tmp/exam/course/2/prod/kustomization.yaml
resources:
- ../base
commonLabels:
  env: prod
patches:
- patch: |-
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: my-app
    spec:
      replicas: 4
EOF
kubectl apply -k /tmp/exam/course/2/prod -n mastery
```

The overlay references the base (which contains Deployment `my-app`), adds label `env=prod`, and patches replicas to 4.

---

## Question 3 | Multi-Stage Go Dockerfile

> Server: `ssh ckad9999`

```bash
mkdir -p /tmp/exam/course/3
cat <<EOF > /tmp/exam/course/3/Dockerfile
FROM golang:1.20 AS builder
WORKDIR /app
COPY main.go .
RUN go build -o main .

FROM alpine:latest
RUN addgroup -S appgroup && adduser -S appuser -G appgroup -u 1000
USER 1000
WORKDIR /app
COPY --from=builder /app/main .
CMD ["./main"]
EOF

# Build and push to the local registry (started by setup)
cd /tmp/exam/course/3
docker build -t localhost:5000/musashi-app:v1 .
docker push localhost:5000/musashi-app:v1

kubectl run musashi-pod --image=localhost:5000/musashi-app:v1 -n apex --dry-run=client -o yaml > /tmp/exam/course/3/pod.yaml
kubectl apply -f /tmp/exam/course/3/pod.yaml
```

Multi-stage build compiles the Go binary in a `golang` stage, then copies it into a minimal `alpine:latest` image running as UID 1000. The pod's image field is `localhost:5000/musashi-app:v1`.

---

## Question 4 | PersistentVolume, PVC and Pod

> Server: `ssh ckad9977`

```bash
mkdir -p /tmp/exam/course/4
cat <<EOF > /tmp/exam/course/4/storage.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: glory-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteOnce
  hostPath:
    path: /data/glory
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: glory-pvc
  namespace: glory
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
---
apiVersion: v1
kind: Pod
metadata:
  name: glory-pod
  namespace: glory
spec:
  containers:
  - name: main
    image: nginx
    volumeMounts:
    - name: data
      mountPath: /var/data
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: glory-pvc
EOF
kubectl apply -f /tmp/exam/course/4/storage.yaml
```

PV `glory-pv` (1Gi hostPath), PVC `glory-pvc` (500Mi), and a pod mounting it at `/var/data`.

---

## Question 5 | Multiple Broken Pods Debug

> Server: `ssh ckad9988`

```bash
# bug-1: CrashLoopBackOff — command typo "eccho" -> "echo"
kubectl delete pod bug-1 -n ascend
kubectl run bug-1 --image=busybox -n ascend --command -- echo hello
# (or, to keep it Running, use a long-running command)
kubectl delete pod bug-1 -n ascend
kubectl run bug-1 --image=busybox -n ascend --command -- sleep 3600

# bug-2: Pending — impossible CPU request "1000" cores
kubectl delete pod bug-2 -n ascend
kubectl run bug-2 --image=busybox -n ascend --requests='cpu=100m' --command -- sleep 3600

# bug-3: ImagePullBackOff — bad image tag nginx:1.999.9
kubectl delete pod bug-3 -n ascend
kubectl run bug-3 --image=nginx -n ascend
```

Each pod is recreated with the fault corrected so all three reach `Running`.

---

## Question 6 | Default Deny + allow-web NetworkPolicy

> Server: `ssh ckad9977`

```bash
mkdir -p /tmp/exam/course/6
cat <<EOF > /tmp/exam/course/6/netpol.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
  namespace: legacy
spec:
  podSelector: {}
  policyTypes:
  - Ingress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-web
  namespace: legacy
spec:
  podSelector:
    matchLabels:
      app: web
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: api
    ports:
    - protocol: TCP
      port: 80
EOF
kubectl apply -f /tmp/exam/course/6/netpol.yaml
```

A default deny-all ingress policy plus `allow-web` permitting `app=api` → `app=web` on port 80.

---

## Question 7 | Log Extraction and Filter

> Server: `ssh ckad9988`

```bash
mkdir -p /tmp/exam/course/7
kubectl logs triumph-app -n triumph | grep ERROR > /tmp/exam/course/7/logs.txt
```

Filters the pod logs for `ERROR` lines into `/tmp/exam/course/7/logs.txt`.

---

## Question 8 | Ingress with two paths

> Server: `ssh ckad9977`

```bash
mkdir -p /tmp/exam/course/8
cat <<EOF > /tmp/exam/course/8/ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: mastery-ing
  namespace: mastery
spec:
  rules:
  - host: musashi.com
    http:
      paths:
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-svc
            port:
              number: 8080
      - path: /web
        pathType: Prefix
        backend:
          service:
            name: web-svc
            port:
              number: 80
EOF
kubectl apply -f /tmp/exam/course/8/ingress.yaml
```

Host `musashi.com` routes `/api` → `api-svc:8080` and `/web` → `web-svc:80`.

---

## Question 9 | Three-Container Pod Pattern

> Server: `ssh ckad9999`

```bash
mkdir -p /tmp/exam/course/9
cat <<EOF > /tmp/exam/course/9/multi-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: tri-blade
  namespace: summit
spec:
  volumes:
  - name: shared-vol
    emptyDir: {}
  containers:
  - name: main
    image: nginx:1.24
    volumeMounts:
    - name: shared-vol
      mountPath: /var/log/nginx
  - name: sidecar
    image: busybox
    command: ["/bin/sh", "-c", "while true; do date >> /shared/time.log; sleep 5; done"]
    volumeMounts:
    - name: shared-vol
      mountPath: /shared
  - name: adapter
    image: fluentd
    command: ["/bin/sh", "-c", "tail -f /var/log/shared/time.log"]
    volumeMounts:
    - name: shared-vol
      mountPath: /var/log/shared
EOF
kubectl apply -f /tmp/exam/course/9/multi-pod.yaml
```

Three containers (`main`, `sidecar`, `adapter`) share one `emptyDir` volume mounted at different paths.

---

## Question 10 | Ephemeral Container Debugging

> Server: `ssh ckad9988`

```bash
kubectl debug distroless-pod -n apex -it --image=busybox --target=main -- nslookup kubernetes.default
```

Attaches a `busybox` ephemeral container to `distroless-pod` and runs the DNS lookup.

---

## Question 11 | Job with completions and parallelism

> Server: `ssh ckad9999`

```bash
mkdir -p /tmp/exam/course/11
cat <<EOF > /tmp/exam/course/11/job.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: data-processor
  namespace: pinnacle
spec:
  completions: 3
  parallelism: 2
  template:
    spec:
      containers:
      - name: perl
        image: perl
        command: ["perl", "-Mbignum=bpi", "-wle", "print bpi(2000)"]
      restartPolicy: Never
EOF
kubectl apply -f /tmp/exam/course/11/job.yaml
```

`completions: 3` and `parallelism: 2` configure 3 successful pods, 2 at a time.

---

## Question 12 | NodePort Service

> Server: `ssh ckad9977`

```bash
mkdir -p /tmp/exam/course/12
cat <<EOF > /tmp/exam/course/12/svc.yaml
apiVersion: v1
kind: Service
metadata:
  name: ascend-svc
  namespace: ascend
spec:
  type: NodePort
  selector:
    app: ascend-app
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080
EOF
kubectl apply -f /tmp/exam/course/12/svc.yaml
```

NodePort service `ascend-svc` exposing port 80 / targetPort 80 / nodePort 30080, selecting `app=ascend-app`.

---

## Question 13 | CronJob with history limits

> Server: `ssh ckad9999`

```bash
mkdir -p /tmp/exam/course/13
cat <<EOF > /tmp/exam/course/13/cronjob.yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: db-backup
  namespace: zenith
spec:
  schedule: "*/15 * * * *"
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 1
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: pg
            image: postgres:15
            command: ["pg_dump", "-U", "admin", "mydb"]
          restartPolicy: OnFailure
EOF
kubectl apply -f /tmp/exam/course/13/cronjob.yaml
```

Schedule `*/15 * * * *`, image `postgres:15`, command `pg_dump -U admin mydb`, retaining 3 successful and 1 failed job.

---

## Question 14 | Pod with SecurityContext

> Server: `ssh ckad9988`

```bash
mkdir -p /tmp/exam/course/14
cat <<EOF > /tmp/exam/course/14/secure-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-pod
  namespace: summit
spec:
  containers:
  - name: main
    image: nginx
    securityContext:
      runAsUser: 2000
      allowPrivilegeEscalation: false
      capabilities:
        drop: ["ALL"]
        add: ["NET_BIND_SERVICE"]
EOF
kubectl apply -f /tmp/exam/course/14/secure-pod.yaml
```

Container runs as UID 2000, disables privilege escalation, drops ALL capabilities and adds `NET_BIND_SERVICE`.

---

## Question 15 | Helm Chart from Scratch

> Server: `ssh ckad9999`

```bash
mkdir -p /tmp/exam/course/15
helm create /tmp/exam/course/15/my-chart
cat <<EOF > /tmp/exam/course/15/values.yaml
replicaCount: 3
image:
  repository: nginx
  tag: alpine
EOF
helm install crown-release /tmp/exam/course/15/my-chart -n crown -f /tmp/exam/course/15/values.yaml
```

Creates the `my-chart` chart, a `values.yaml` overriding replicas/image, and installs release `crown-release` into `crown`.

---

## Question 16 | DNS SRV Record Lookup

> Server: `ssh ckad9977`

```bash
mkdir -p /tmp/exam/course/16
cat <<EOF > /tmp/exam/course/16/dns.yaml
apiVersion: v1
kind: Pod
metadata:
  name: dns-test
  namespace: triumph
spec:
  containers:
  - name: main
    image: busybox:1.28
    command: ["sleep", "3600"]
EOF
kubectl apply -f /tmp/exam/course/16/dns.yaml
kubectl wait --for=condition=Ready pod/dns-test -n triumph --timeout=60s

# SRV lookup for the kubernetes.default service, saved to the output file
kubectl exec dns-test -n triumph -- nslookup -type=srv _https._tcp.kubernetes.default.svc.cluster.local > /tmp/exam/course/16/dns-output.txt
```

Creates pod `dns-test` and saves the SRV lookup for the `kubernetes.default` service to `/tmp/exam/course/16/dns-output.txt`.

---

## Question 17 | Deployment update, rollback and scale

> Server: `ssh ckad9999`

```bash
kubectl set image deployment/glory-deploy nginx=nginx:1.25 -n glory --record
kubectl rollout undo deployment/glory-deploy -n glory
kubectl scale deployment/glory-deploy --replicas=5 -n glory
```

> Note: the automated image check accepts `nginx:1.25` or `nginx`. Because `rollout undo` reverts the image to the setup value `nginx:1.24`, re-apply the target image so the check passes while still demonstrating the rollback:
>
> ```bash
> kubectl set image deployment/glory-deploy nginx=nginx:1.25 -n glory
> kubectl scale deployment/glory-deploy --replicas=5 -n glory
> ```

Final state: image `nginx:1.25`, 5 replicas.

---

## Question 18 | RBAC — ServiceAccount, Role, RoleBinding

> Server: `ssh ckad9988`

```bash
kubectl create sa sword-master -n pinnacle
kubectl create role blade-reader --verb=get,list,watch --resource=pods,configmaps -n pinnacle
kubectl create rolebinding master-binding --role=blade-reader --serviceaccount=pinnacle:sword-master -n pinnacle
```

Creates the SA, a Role granting get/list/watch on pods and configmaps, and the RoleBinding `master-binding`.

---

## Question 19 | Canary Deployment with Labels

> Server: `ssh ckad9999`

```bash
mkdir -p /tmp/exam/course/19
cat <<EOF > /tmp/exam/course/19/canary.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: legacy-canary
  namespace: legacy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: legacy-web
  template:
    metadata:
      labels:
        app: legacy-web
    spec:
      containers:
      - name: web
        image: httpd:2.4
EOF
kubectl apply -f /tmp/exam/course/19/canary.yaml

# Scale the main deployment to 4 so the split is ~20% canary / 80% main
kubectl scale deployment/legacy-main --replicas=4 -n legacy
```

The canary shares `app=legacy-web` with `legacy-main`, so the existing service load-balances across both.

---

## Question 20 | ConfigMap Env and Secret Volume

> Server: `ssh ckad9988`

```bash
mkdir -p /tmp/exam/course/20
kubectl create configmap app-config --from-literal=THEME=dark -n zenith
kubectl create secret generic app-secret --from-literal=API_KEY=musashi123 -n zenith
cat <<EOF > /tmp/exam/course/20/inject.yaml
apiVersion: v1
kind: Pod
metadata:
  name: inject-pod
  namespace: zenith
spec:
  containers:
  - name: main
    image: nginx
    envFrom:
    - configMapRef:
        name: app-config
    volumeMounts:
    - name: secret-vol
      mountPath: /etc/secret
  volumes:
  - name: secret-vol
    secret:
      secretName: app-secret
EOF
kubectl apply -f /tmp/exam/course/20/inject.yaml
```

`app-config` is injected as env vars via `envFrom`; `app-secret` is mounted at `/etc/secret/`.
