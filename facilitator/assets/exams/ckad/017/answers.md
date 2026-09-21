# CKAD Simulation 15 — Answers

> Dojo Susanoo 🌊 — *「スサノオは海を支配する」- Susanoo commands the seas*
>
> Everything runs on the single `ckad9999` jumphost against one shared cluster. Course files live under `/tmp/exam/course/...`.

---

## Question 1 | Multi-Stage Dockerfile

Modify the `Dockerfile` to use a multi-stage build, copying the built artifact from the first stage.

```bash
cat <<EOF > /tmp/exam/course/1/Dockerfile
FROM golang:1.20-alpine AS builder
WORKDIR /app
COPY main.go .
RUN go build -o app main.go

FROM alpine:3.18
WORKDIR /app
COPY --from=builder /app/app /app/app
CMD ["./app"]
EOF
```

---

## Question 2 | Sidecar Pod

Two containers sharing an `emptyDir` volume; the main writes logs, the sidecar tails them.

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: log-generator
  namespace: tide
spec:
  containers:
  - name: app
    image: busybox
    command: ["sh", "-c", "while true; do echo \"\$(date) - Application log\" >> /var/log/app/app.log; sleep 5; done"]
    volumeMounts:
    - name: shared-logs
      mountPath: /var/log/app
  - name: sidecar
    image: busybox
    command: ["sh", "-c", "tail -f /var/log/app/app.log"]
    volumeMounts:
    - name: shared-logs
      mountPath: /var/log/app
  volumes:
  - name: shared-logs
    emptyDir: {}
EOF
```

---

## Question 3 | CronJob with Concurrency Policy

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: data-sync
  namespace: coral
spec:
  schedule: "*/10 * * * *"
  failedJobsHistoryLimit: 5
  suspend: true
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: sync
            image: busybox
            command:
            - echo
            - "Syncing data..."
          restartPolicy: OnFailure
EOF
```

---

## Question 4 | Batch Pod with restartPolicy

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: batch-worker
  namespace: abyss
spec:
  restartPolicy: OnFailure
  containers:
  - name: worker
    image: busybox
    command: ["sh", "-c", "echo \"Processing batch\"; exit 1"]
EOF
```

---

## Question 5 | Uninstall Helm Release

```bash
helm uninstall ocean-api -n current
```

---

## Question 6 | Deployment with Rolling Update Strategy

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deploy
  namespace: reef
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 50%
      maxUnavailable: 25%
  selector:
    matchLabels:
      app: web-deploy
  template:
    metadata:
      labels:
        app: web-deploy
    spec:
      containers:
      - name: nginx
        image: nginx:1.23
EOF
```

---

## Question 7 | Deployment Rollback

```bash
# Update to nginx:1.24 and record cause (revision 2)
kubectl set image deployment/api-server nginx=nginx:1.24 -n lagoon
kubectl annotate deployment api-server kubernetes.io/change-cause="update to 1.24" -n lagoon

# Update to nginx:1.25 and record cause (revision 3)
kubectl set image deployment/api-server nginx=nginx:1.25 -n lagoon
kubectl annotate deployment api-server kubernetes.io/change-cause="update to 1.25" -n lagoon

# Inspect history to find the nginx:1.24 revision
kubectl rollout history deployment/api-server -n lagoon

# Roll back to the nginx:1.24 revision (revision 2 in this sequence)
kubectl rollout undo deployment/api-server --to-revision=2 -n lagoon
```

---

## Question 8 | Kustomize with commonLabels/commonAnnotations

```bash
mkdir -p /tmp/exam/course/8
cd /tmp/exam/course/8
kubectl create deployment app-deploy --image=nginx --dry-run=client -o yaml > deployment.yaml
kubectl create service clusterip app-svc --tcp=80:80 --dry-run=client -o yaml > service.yaml

cat <<EOF > kustomization.yaml
resources:
- deployment.yaml
- service.yaml

commonLabels:
  env: production
  team: alpha

commonAnnotations:
  release: v1.0.0
EOF

kubectl apply -k . -n trench
```

---

## Question 9 | Fix ErrImagePull Pod

```bash
kubectl get pod backend-pod -n wave -o yaml > /tmp/exam/pod.yaml
# Change image from wrongregistry.k8s.io/nginx:alpine to nginx:alpine
sed -i 's#wrongregistry.k8s.io/nginx:alpine#nginx:alpine#g' /tmp/exam/pod.yaml
kubectl delete pod backend-pod -n wave
kubectl apply -f /tmp/exam/pod.yaml
```

---

## Question 10 | Extract Warning Events

```bash
mkdir -p /tmp/exam/course/10
kubectl get events -n depths --field-selector type=Warning > /tmp/exam/course/10/events.txt
```

---

## Question 11 | gRPC Liveness Probe

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: grpc-checker
  namespace: ocean
spec:
  containers:
  - name: app
    image: nginx:1.24
    livenessProbe:
      grpc:
        port: 8080
      initialDelaySeconds: 5
      periodSeconds: 10
EOF
```

---

## Question 12 | ConfigMap from Directory Mounted as Volume

```bash
kubectl create configmap app-config-dir --from-file=/tmp/exam/course/12/config-files/ -n tide

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: config-consumer
  namespace: tide
spec:
  containers:
  - name: app
    image: alpine
    command: ["sleep", "3600"]
    volumeMounts:
    - name: config-vol
      mountPath: /etc/config
  volumes:
  - name: config-vol
    configMap:
      name: app-config-dir
EOF
```

---

## Question 13 | Secret Exposed as Env Vars

```bash
kubectl create secret generic db-credentials \
  --from-literal=username=admin \
  --from-literal=password=supersecretpassword -n coral

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: secret-env-pod
  namespace: coral
spec:
  containers:
  - name: app
    image: nginx
    env:
    - name: DB_USER
      valueFrom:
        secretKeyRef:
          name: db-credentials
          key: username
    - name: DB_PASS
      valueFrom:
        secretKeyRef:
          name: db-credentials
          key: password
EOF
```

---

## Question 14 | SecurityContext + NetworkPolicy

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: secure-pod
  namespace: abyss
  labels:
    app: secure
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 3000
  containers:
  - name: app
    image: busybox
    command: ["sleep", "3600"]
    securityContext:
      allowPrivilegeEscalation: false
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: secure-policy
  namespace: abyss
spec:
  podSelector:
    matchLabels:
      app: secure
  policyTypes:
  - Ingress
  - Egress
  egress:
  - {}
EOF
```

---

## Question 15 | Ephemeral Debug Container

```bash
kubectl debug target-pod -n reef --image=busybox --container=debug-container
```

---

## Question 16 | Deployment + PodDisruptionBudget

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: critical-app
  namespace: lagoon
spec:
  replicas: 3
  selector:
    matchLabels:
      tier: critical
  template:
    metadata:
      labels:
        tier: critical
    spec:
      containers:
      - name: nginx
        image: nginx
---
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: critical-pdb
  namespace: lagoon
spec:
  minAvailable: 2
  selector:
    matchLabels:
      tier: critical
EOF
```

---

## Question 17 | Deny-all + Allow-web NetworkPolicies

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
  namespace: trench
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-web
  namespace: trench
spec:
  podSelector:
    matchLabels:
      role: web
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - ports:
    - protocol: TCP
      port: 80
  egress:
  - {}
EOF
```

---

## Question 18 | Fix Service Selector

```bash
kubectl patch service mesh-service -n wave -p '{"spec":{"selector":{"app":"mesh-app"}}}'
# or: kubectl edit service mesh-service -n wave   (change selector to app: mesh-app)
```

---

## Question 19 | Multi-Port Service

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: multi-port-svc
  namespace: depths
spec:
  selector:
    app: multi-app
  ports:
  - name: http
    port: 80
    targetPort: 8080
    protocol: TCP
  - name: dns
    port: 53
    targetPort: 5353
    protocol: UDP
EOF
```

---

## Question 20 | Rewrite-Target Ingress

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: rewrite-ingress
  namespace: ocean
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /\$2
spec:
  ingressClassName: nginx
  rules:
  - host: susanoo.com
    http:
      paths:
      - path: /api(/|\$)(.*)
        pathType: ImplementationSpecific
        backend:
          service:
            name: api-service
            port:
              number: 80
EOF
```
