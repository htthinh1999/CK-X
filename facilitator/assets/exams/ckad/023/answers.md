# CKAD Multi-Cluster Practice Lab — Answers

This lab models an app promoted across **three environments, each its own cluster**.
Each environment is a separate server whose cluster is already the default (and only)
context — just `ssh` to the instance named in the question and work there. There is no
context to switch:

- `dev`     → `ssh ckad9999` (namespace `dev`)
- `staging` → `ssh ckad9988` (namespace `staging`)
- `prod`    → `ssh ckad9977` (namespace `prod`)

---

## dev cluster (`ssh ckad9999`)

### Question 1 — Multi-container Pod with shared volume

```bash
cat <<'YAML' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: sidecar-pod
  namespace: dev
spec:
  volumes:
    - name: shared
      emptyDir: {}
  containers:
    - name: main
      image: nginx:1.25
      volumeMounts:
        - name: shared
          mountPath: /usr/share/nginx/html
    - name: sidecar
      image: busybox:1.36
      command: ["sh", "-c", "sleep 3600"]
      volumeMounts:
        - name: shared
          mountPath: /work
YAML
```

### Question 2 — Resource requests/limits

```bash
kubectl -n dev run limited --image=nginx:1.25 \
  --restart=Never \
  -o yaml --dry-run=client > limited.yaml
# add resources.requests {cpu:100m,memory:64Mi} and limits {cpu:200m,memory:128Mi}, then:
kubectl apply -f limited.yaml
```

### Question 3 — ConfigMap as volume

```bash
kubectl -n dev create configmap feature-flags --from-literal=DARK_MODE=true --from-literal=BETA=false
cat <<'YAML' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata: { name: flags-app, namespace: dev }
spec:
  replicas: 1
  selector: { matchLabels: { app: flags-app } }
  template:
    metadata: { labels: { app: flags-app } }
    spec:
      volumes:
        - name: flags
          configMap: { name: feature-flags }
      containers:
        - name: app
          image: nginx:1.25
          volumeMounts:
            - { name: flags, mountPath: /etc/flags }
YAML
```

### Question 4 — Liveness + readiness probes

```bash
cat <<'YAML' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata: { name: probed, namespace: dev }
spec:
  containers:
    - name: web
      image: nginx:1.25
      livenessProbe:  { httpGet: { path: /, port: 80 } }
      readinessProbe: { httpGet: { path: /, port: 80 } }
YAML
```

---

## staging cluster (`ssh ckad9988`)

### Question 5 — Job

```bash
cat <<'YAML' | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata: { name: batch, namespace: staging }
spec:
  completions: 3
  parallelism: 2
  backoffLimit: 4
  template:
    spec:
      restartPolicy: Never
      containers:
        - { name: worker, image: busybox:1.36, command: ["sh","-c","echo done"] }
YAML
```

### Question 6 — securityContext

```bash
cat <<'YAML' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata: { name: secured, namespace: staging }
spec:
  securityContext: { runAsUser: 1000 }
  containers:
    - name: app
      image: nginx:1.25
      securityContext: { allowPrivilegeEscalation: false }
YAML
```

### Question 7 — Rolling update

```bash
kubectl -n staging set image deployment/rollme app=nginx:1.25
kubectl -n staging rollout status deployment/rollme
```

### Question 8 — Deployment + ClusterIP Service

```bash
kubectl -n staging create deployment store --image=nginx:1.25 --replicas=2
kubectl -n staging expose deployment store --name=store-svc --port=80 --target-port=80
```

---

## prod cluster (`ssh ckad9977`)

### Question 9 — Secret as volume

```bash
kubectl -n prod create secret generic app-secret --from-literal=api-key=abc123 --from-literal=token=xyz789
cat <<'YAML' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata: { name: secret-consumer, namespace: prod }
spec:
  volumes:
    - name: sec
      secret: { secretName: app-secret }
  containers:
    - name: app
      image: busybox:1.36
      command: ["sh", "-c", "sleep 3600"]
      volumeMounts:
        - { name: sec, mountPath: /etc/secret }
YAML
```

### Question 10 — Ingress

```bash
cat <<'YAML' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata: { name: shop-ing, namespace: prod }
spec:
  rules:
    - host: shop.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: shop-svc
                port: { number: 80 }
YAML
```

### Question 11 — CronJob

```bash
cat <<'YAML' | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata: { name: backup, namespace: prod }
spec:
  schedule: "0 */6 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
            - { name: backup, image: busybox:1.36, command: ["sh","-c","echo backup"] }
YAML
```

### Question 12 — NetworkPolicy

```bash
cat <<'YAML' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata: { name: allow-web, namespace: prod }
spec:
  podSelector: { matchLabels: { app: web } }
  policyTypes: [Ingress]
  ingress:
    - from:
        - podSelector: { matchLabels: { app: client } }
YAML
```
