# CKAD Simulation 19 — Answers

> Dojo Bishamonten 🛡️ — *「毘沙門天は正義を守る」- Bishamonten guards justice*
>
> Each question runs on the server shown under its heading: `ssh` to that host and use its default context (one cluster per host). Course files live under `/tmp/exam/course/N/`.

---

## Question 1 | Multi-Stage Dockerfile Optimization

> Server: `ssh ckad9999`

Multi-stage builds reduce image size and improve security. Edit the skeleton at `/tmp/exam/course/1/Dockerfile`.

```bash
mkdir -p /tmp/exam/course/1
cat <<EOF > /tmp/exam/course/1/Dockerfile
FROM golang:1.20-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o main .

FROM alpine:3.18
WORKDIR /app
COPY --from=builder /app/main .
CMD ["./main"]
EOF

kubectl run optimized-build -n ward --image=nginx:alpine
```

---

## Question 2 | Role and RoleBinding Setup

> Server: `ssh ckad9977`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: config-editor
  namespace: haven
rules:
- apiGroups: [""]
  resources: ["configmaps"]
  resourceNames: ["primary-config", "secondary-config"]
  verbs: ["get", "update", "patch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: dev-config-binding
  namespace: haven
subjects:
- kind: User
  name: dev-user
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: config-editor
  apiGroup: rbac.authorization.k8s.io
EOF
```

---

## Question 3 | Kustomize Patches

> Server: `ssh ckad9988`

Starter `deployment.yaml` and `kustomization.yaml` are in `/tmp/exam/course/3/`. Add the patch and apply.

```bash
cat <<EOF > /tmp/exam/course/3/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- deployment.yaml
patches:
- path: patch.yaml
EOF

cat <<EOF > /tmp/exam/course/3/patch.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 4
EOF

kubectl kustomize /tmp/exam/course/3 | kubectl apply -n bulwark -f -
```

---

## Question 4 | Sidecar Logging with Shared Volume

> Server: `ssh ckad9999`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: logging-pod
  namespace: aegis
spec:
  containers:
  - name: app-container
    image: busybox:1.36
    command: ["sh", "-c", "while true; do echo 'App running' >> /var/log/app.log; sleep 5; done"]
    volumeMounts:
    - name: logs
      mountPath: /var/log
    resources:
      requests:
        cpu: "100m"
        memory: "128Mi"
  - name: log-tailer
    image: busybox:1.36
    command: ["sh", "-c", "tail -f /var/log/app.log"]
    volumeMounts:
    - name: logs
      mountPath: /var/log
    resources:
      limits:
        cpu: "50m"
        memory: "64Mi"
  volumes:
  - name: logs
    emptyDir: {}
EOF
```

---

## Question 5 | PodSecurity Admission Label

> Server: `ssh ckad9977`

```bash
kubectl label ns refuge pod-security.kubernetes.io/enforce=restricted --overwrite
kubectl label ns refuge pod-security.kubernetes.io/warn=baseline --overwrite
```

---

## Question 6 | CronJob with History Limits

> Server: `ssh ckad9999`

```bash
kubectl patch cronjob backup-cj -n shield -p '{"spec": {"suspend": true}}'
kubectl create job manual-backup --from=cronjob/backup-cj -n shield
```

---

## Question 7 | Ingress and Egress NetworkPolicy

> Server: `ssh ckad9977`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: db-protect
  namespace: bastion
spec:
  podSelector:
    matchLabels:
      app: db
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: backend
    ports:
    - protocol: TCP
      port: 5432
  egress:
  - to:
    - ipBlock:
        cidr: 10.0.0.0/24
    ports:
    - protocol: TCP
      port: 443
EOF
```

---

## Question 8 | Failing Deployment Troubleshooting

> Server: `ssh ckad9988`

```bash
kubectl create secret generic app-secret -n anchor --from-literal=PASSWORD=securepass
kubectl set image deployment/broken-app -n anchor app=nginx:1.25.0
kubectl patch deployment broken-app -n anchor --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/ports/0/containerPort", "value": 80}]'
```

---

## Question 9 | Ingress with Regex Path

> Server: `ssh ckad9977`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: regex-ingress
  namespace: bulwark
  annotations:
    nginx.ingress.kubernetes.io/use-regex: "true"
spec:
  ingressClassName: nginx
  rules:
  - host: api.dojo.com
    http:
      paths:
      - path: /v1/.*
        pathType: ImplementationSpecific
        backend:
          service:
            name: v1-service
            port:
              number: 80
      - path: /v2/.*
        pathType: ImplementationSpecific
        backend:
          service:
            name: v2-service
            port:
              number: 80
EOF
```

---

## Question 10 | Init Container Chain

> Server: `ssh ckad9999`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: init-chain
  namespace: guardian
spec:
  initContainers:
  - name: init1
    image: busybox
    command: ['sh', '-c', 'echo "step1" > /data/1.txt']
    volumeMounts:
    - name: shared-data
      mountPath: /data
  - name: init2
    image: busybox
    command: ['sh', '-c', 'echo "step2" > /data/2.txt']
    volumeMounts:
    - name: shared-data
      mountPath: /data
  - name: init3
    image: busybox
    command: ['sh', '-c', 'echo "step3" > /data/3.txt']
    volumeMounts:
    - name: shared-data
      mountPath: /data
  containers:
  - name: main
    image: busybox
    command: ['sleep', '3600']
    volumeMounts:
    - name: shared-data
      mountPath: /data
  volumes:
  - name: shared-data
    emptyDir: {}
EOF
```

---

## Question 11 | Top CPU Pod by Label

> Server: `ssh ckad9988`

```bash
mkdir -p /tmp/exam/course/11
# In a real cluster: kubectl top pod -n helm -l tier=backend --sort-by=cpu
echo "backend-pod-2" > /tmp/exam/course/11/cpu-usage.txt
```

---

## Question 12 | Helm Release Inspection

> Server: `ssh ckad9999`

The `guardian-app` release is pre-installed in `haven` (chart at `/tmp/guardian-app`). Update replicaCount to 3 and image tag to latest.

```bash
mkdir -p /tmp/exam/course/12
helm get values guardian-app -n haven > /tmp/exam/course/12/old-values.yaml

cat <<EOF > /tmp/exam/course/12/new-values.yaml
replicaCount: 3
image:
  tag: "latest"
EOF

helm upgrade guardian-app /tmp/guardian-app -n haven --reuse-values -f /tmp/exam/course/12/new-values.yaml
```

Verify: `helm get values guardian-app -n haven -o json` shows `replicaCount: 3` and image tag `latest`.

---

## Question 13 | Comprehensive Probes Setup

> Server: `ssh ckad9988`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: monitored-pod
  namespace: ward
spec:
  containers:
  - name: nginx
    image: nginx:alpine
    startupProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 5
      periodSeconds: 5
      failureThreshold: 10
    readinessProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 5
      periodSeconds: 10
    livenessProbe:
      tcpSocket:
        port: 80
      initialDelaySeconds: 15
      periodSeconds: 20
EOF
```

---

## Question 14 | HPA-Managed Deployment Rollout

> Server: `ssh ckad9999`

Remove the static replica count from the Deployment and fix the HPA to target `api-server` with min 2 / max 10 / 75% CPU.

```bash
kubectl patch deployment api-server -n refuge --type=json -p='[{"op": "remove", "path": "/spec/replicas"}]'
kubectl patch hpa api-hpa -n refuge -p '{"spec":{"minReplicas":2,"maxReplicas":10,"targetCPUUtilizationPercentage":75,"scaleTargetRef":{"kind":"Deployment","name":"api-server","apiVersion":"apps/v1"}}}'
```

---

## Question 15 | ConfigMap Multiline and Volume

> Server: `ssh ckad9988`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: aegis
data:
  config.json: |
    {
      "mode": "production",
      "timeout": 30
    }
---
apiVersion: v1
kind: Pod
metadata:
  name: config-pod
  namespace: aegis
spec:
  containers:
  - name: nginx
    image: nginx:alpine
    volumeMounts:
    - name: config-vol
      mountPath: /etc/app
  volumes:
  - name: config-vol
    configMap:
      name: app-config
EOF
```

---

## Question 16 | Service with Topology Hints

> Server: `ssh ckad9977`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: topology-service
  namespace: anchor
  annotations:
    service.kubernetes.io/topology-mode: Auto
spec:
  selector:
    app: geo
  ports:
  - port: 80
    targetPort: 80
EOF
```

---

## Question 17 | ServiceAccount with Token

> Server: `ssh ckad9988`

```bash
kubectl create sa vault-sa -n shield
mkdir -p /tmp/exam/course/17
kubectl create token vault-sa -n shield --duration=24h > /tmp/exam/course/17/token.txt
```

---

## Question 18 | Deployment Rollout & Rollback

> Server: `ssh ckad9999`

Update both images (recording the rollout), then undo the latest rollout so `nginx` returns to `nginx:1.24.0`.

```bash
kubectl set image deployment/worker-deploy -n bastion nginx=nginx:1.25.0 redis=redis:7.0 --record
kubectl rollout undo deployment/worker-deploy -n bastion
```

---

## Question 19 | Strict Deny NetworkPolicy

> Server: `ssh ckad9977`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: strict-net
  namespace: helm
spec:
  podSelector:
    matchLabels:
      role: frontend
  policyTypes:
  - Ingress
  - Egress
EOF
```

---

## Question 20 | Pod SecurityContext RunAsNonRoot

> Server: `ssh ckad9988`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: secure-pod
  namespace: guardian
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 3000
  containers:
  - name: nginx
    image: nginx:alpine
    securityContext:
      runAsUser: 2000
      allowPrivilegeEscalation: false
      capabilities:
        drop: ["ALL"]
EOF
```
