# CKAD Simulation 12 — Answers

> Dojo Tsukuyomi 🌙 — *「月読は闇を照らす」- Tsukuyomi illuminates the darkness*
>
> Path remapping for CK-X: `/opt/course/N/` and `./exam/course/N/` → `/tmp/exam/course/N/`. Each question runs on the server shown under its heading: `ssh` to that host and use its default context (one cluster per host).

---

## Question 1 | Secret rotation

> Server: `ssh ckad9977`

```bash
kubectl create secret generic legacy-token -n shadow \
  --from-literal=token=super-secret-v2 \
  --dry-run=client -o yaml | kubectl apply -f -
```

---

## Question 2 | Multi-stage Dockerfile

> Server: `ssh ckad9999`

```dockerfile
# /tmp/exam/course/2/Dockerfile
FROM golang:1.20-alpine AS builder
COPY main.go /app/
RUN go build -o /app/server /app/main.go

FROM alpine:3.18
COPY --from=builder /app/server /opt/server
ENTRYPOINT ["/opt/server"]
```

Explanation: Multi-stage builds use `AS builder` to name the first stage, compile the binary, then `COPY --from=builder` into a minimal alpine stage.

---

## Question 3 | Kustomize with JSON patch

> Server: `ssh ckad9988`

```json
// /tmp/exam/course/3/patch.json
[
  {
    "op": "add",
    "path": "/spec/template/spec/containers/0/env",
    "value": [
      {
        "name": "MODE",
        "value": "production"
      }
    ]
  }
]
```

```yaml
# /tmp/exam/course/3/kustomization.yaml
resources:
  - deployment.yaml

patches:
  - target:
      kind: Deployment
      name: frontend
    path: patch.json
```

---

## Question 4 | ResourceQuota

> Server: `ssh ckad9977`

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: nightfall
spec:
  hard:
    pods: "4"
    requests.cpu: "2"
    limits.memory: "4Gi"
```

---

## Question 5 | Init containers with dependencies

> Server: `ssh ckad9999`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: data-processor
  namespace: crescent
spec:
  initContainers:
  - name: wait-for-service
    image: busybox:1.36
    command: ['sh', '-c', 'sleep 5 && echo "Dependencies ready"']
  containers:
  - name: main-app
    image: nginx:alpine
```

Init containers run to completion before the main app containers start.

---

## Question 6 | NetworkPolicy egress rules

> Server: `ssh ckad9977`

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-external
  namespace: dusk
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - {} # allow all ingress
  egress:
  - ports:
    - protocol: UDP
      port: 53
```

---

## Question 7 | CronJob with concurrencyPolicy

> Server: `ssh ckad9999`

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: nightly-backup
  namespace: twilight
spec:
  schedule: "*/10 * * * *"
  concurrencyPolicy: Forbid
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: backup
            image: busybox:1.36
            command: ["sh", "-c", "sleep 30"]
          restartPolicy: OnFailure
```

`concurrencyPolicy: Forbid` skips the next run if the previous one hasn't finished.

---

## Question 8 | Debug ImagePullBackOff

> Server: `ssh ckad9988`

The pod `metrics-gatherer` in `starlight` uses a misspelled image (`nginxxxxx:alpine`). Fix the image to a valid one (e.g. `nginx:alpine`). The simplest reliable approach is to recreate it:

```bash
kubectl delete pod metrics-gatherer -n starlight
kubectl run metrics-gatherer -n starlight --image=nginx:alpine
```

Or edit in place and change the image:

```bash
kubectl set image pod/metrics-gatherer gatherer=nginx:alpine -n starlight
# (if the field is immutable for a bare pod, delete and recreate as above)
```

A misspelled image name triggers ImagePullBackOff because the node cannot pull a non-existent image.

---

## Question 9 | Multi-path Ingress

> Server: `ssh ckad9977`

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: star-ingress
  namespace: starlight
spec:
  ingressClassName: nginx
  rules:
  - http:
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
```

---

## Question 10 | Container resource metrics

> Server: `ssh ckad9988`

```bash
kubectl top pods -n kube-system --sort-by=cpu
# Record the top pod's name
kubectl top pods -n kube-system --sort-by=cpu --no-headers | head -1 | awk '{print $1}' \
  > /tmp/exam/course/10/cpu-usage.txt
cat /tmp/exam/course/10/cpu-usage.txt
```

On k3s there are no kube-apiserver/etcd Pods (the control plane runs inside the k3s
process), so the top consumer is usually `metrics-server-…`, `coredns-…` or `traefik-…`.
Scoring checks that the file names a real Pod in `kube-system`.

---

## Question 11 | Multi-container ambassador pattern

> Server: `ssh ckad9999`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: legacy-app
  namespace: eclipse
spec:
  containers:
  - name: backend
    image: nginx:1.25
    ports:
    - containerPort: 80
  - name: proxy
    image: haproxy:2.8-alpine
```

---

## Question 12 | ExternalName Service

> Server: `ssh ckad9977`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: db-ext-svc
  namespace: nebula
spec:
  type: ExternalName
  externalName: database.external.example.com
```

---

## Question 13 | Log aggregation sidecar

> Server: `ssh ckad9988`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: logger
  namespace: lunar
spec:
  volumes:
  - name: log-volume
    emptyDir: {}
  containers:
  - name: app
    image: busybox:1.36
    command: ['sh', '-c', 'while true; do echo "App is running" >> /var/log/app.log; sleep 5; done']
    volumeMounts:
    - name: log-volume
      mountPath: /var/log
  - name: log-tailer
    image: busybox:1.36
    command: ['sh', '-c', 'tail -f /var/log/app.log']
    volumeMounts:
    - name: log-volume
      mountPath: /var/log
```

---

## Question 14 | Helm rollback

> Server: `ssh ckad9999`

```bash
helm rollback api-release 1 -n nebula
```

`helm rollback <release> <revision>` returns the release to revision 1. The history entry gets the description `Rollback to 1`.

---

## Question 15 | Projected volume (secret + configmap)

> Server: `ssh ckad9988`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: combined-app
  namespace: crescent
spec:
  containers:
  - name: app
    image: nginx:alpine
    volumeMounts:
    - name: all-in-one
      mountPath: /opt/config
  volumes:
  - name: all-in-one
    projected:
      sources:
      - secret:
          name: db-creds
      - configMap:
          name: app-config
```

---

## Question 16 | Deployment with minReadySeconds

> Server: `ssh ckad9999`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: slow-start-app
  namespace: shadow
spec:
  replicas: 3
  selector:
    matchLabels:
      app: slow-start-app
  minReadySeconds: 20
  template:
    metadata:
      labels:
        app: slow-start-app
    spec:
      containers:
      - name: nginx
        image: nginx:1.24
```

---

## Question 17 | Immutable ConfigMap

> Server: `ssh ckad9988`

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: static-config
  namespace: twilight
data:
  version: v2.1.0
immutable: true
```

---

## Question 18 | DNS debugging

> Server: `ssh ckad9977`

```bash
kubectl exec dns-tester -n void -- nslookup kubernetes.default.svc.cluster.local > /tmp/exam/course/18/nslookup.txt
cat /tmp/exam/course/18/nslookup.txt
```

`nslookup` confirms CoreDNS is resolving the in-cluster service name.

---

## Question 19 | Pod with security constraints

> Server: `ssh ckad9988`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-pod
  namespace: eclipse
spec:
  securityContext:
    runAsUser: 1000
  containers:
  - name: nginx
    image: nginx:alpine
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
    volumeMounts:
    - name: nginx-cache
      mountPath: /var/cache/nginx
    - name: nginx-run
      mountPath: /var/run
  volumes:
  - name: nginx-cache
    emptyDir: {}
  - name: nginx-run
    emptyDir: {}
```

---

## Question 20 | Rollout pause

> Server: `ssh ckad9999`

```bash
kubectl rollout pause deployment critical-processor -n nightfall
```

Pausing halts the update so no further pods roll out while you investigate.
