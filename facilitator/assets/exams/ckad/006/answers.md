# CKAD Simulation 4 — Answers

> Dojo Kappa 🐸 — 「河童は水を知る」 The kappa knows the waters
>
> Total Score: 91 points | Passing Score: ~66% (60 points)
>
> Original Questions: Adapted from [CKAD-Practice-Questions](https://github.com/aravind4799/CKAD-Practice-Questions) by [@aravind4799](https://github.com/aravind4799)
>
> Path note: `/opt/course/N/` from the original maps to `/tmp/exam/course/N/` on the question's server. Each question runs on the server shown under its heading: `ssh` to that host and use its default context (one cluster per host).

---

## Question 1 | Fix Broken Pod with Correct ServiceAccount (4 points)

> Server: `ssh ckad9977`

The `monitor-binding` RoleBinding binds `monitor-sa` to the `metrics-reader` Role (which grants get/list/watch on pods), so `monitor-sa` is the correct ServiceAccount.

```bash
# Step 1: Investigate existing RBAC resources
kubectl get rolebindings -n delta
kubectl describe rolebinding monitor-binding -n delta
kubectl describe role metrics-reader -n delta

# Step 2: Update Pod to use monitor-sa
kubectl get pod metrics-pod -n delta -o yaml > /tmp/metrics-pod.yaml
# Edit /tmp/metrics-pod.yaml to set:  spec.serviceAccountName: monitor-sa
kubectl delete pod metrics-pod -n delta
kubectl apply -f /tmp/metrics-pod.yaml

# Step 3: Verify
kubectl get pod metrics-pod -n delta
kubectl logs metrics-pod -n delta
```

---

## Question 2 | Secret from Hardcoded Variables (4 points)

> Server: `ssh ckad9999`

```bash
# Step 1: Create the Secret
kubectl create secret generic db-credentials \
  --from-literal=DB_USER=admin \
  --from-literal=DB_PASS=Secret123! \
  -n stream

# Step 2: Update Deployment to use Secret
kubectl edit deploy api-server -n stream
```

Replace the hardcoded environment variables with:

```yaml
env:
  - name: DB_USER
    valueFrom:
      secretKeyRef:
        name: db-credentials
        key: DB_USER
  - name: DB_PASS
    valueFrom:
      secretKeyRef:
        name: db-credentials
        key: DB_PASS
```

```bash
# Verify
kubectl rollout status deploy api-server -n stream
kubectl get secret db-credentials -n stream
```

---

## Question 3 | Fix NetworkPolicy by Updating Pod Labels (8 points)

> Server: `ssh ckad9988`

```bash
# Step 1: View existing NetworkPolicies
kubectl get networkpolicies -n spring -o yaml

# Step 2: Update Pod labels
kubectl label pod frontend -n spring role=frontend --overwrite
kubectl label pod backend -n spring role=backend --overwrite
kubectl label pod database -n spring role=db --overwrite

# Verify
kubectl get pods -n spring --show-labels
```

---

## Question 4 | CronJob with Schedule and History Limits (8 points)

> Server: `ssh ckad9999`

```bash
kubectl apply -f - <<EOF
apiVersion: batch/v1
kind: CronJob
metadata:
  name: backup-job
  namespace: pond
spec:
  schedule: "*/30 * * * *"
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 2
  jobTemplate:
    spec:
      activeDeadlineSeconds: 300
      template:
        spec:
          restartPolicy: Never
          containers:
            - name: backup
              image: busybox:latest
              command: ["/bin/sh", "-c"]
              args: ["echo Backup completed"]
EOF

# Verify
kubectl get cronjob backup-job -n pond
kubectl describe cronjob backup-job -n pond
```

---

## Question 5 | Fix Broken Deployment YAML (4 points)

> Server: `ssh ckad9988`

Edit `/tmp/exam/course/5/broken-deploy.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: broken-app
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
        - name: web
          image: nginx
```

```bash
# Apply and verify
kubectl apply -f /tmp/exam/course/5/broken-deploy.yaml
kubectl get deploy broken-app
kubectl rollout status deploy broken-app
```

---

## Question 6 | Create NodePort Service (4 points)

> Server: `ssh ckad9977`

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: api-nodeport
  namespace: default
spec:
  type: NodePort
  selector:
    app: api
  ports:
    - port: 80
      targetPort: 9090
      protocol: TCP
EOF

# Verify
kubectl get svc api-nodeport -n default
kubectl describe svc api-nodeport -n default
```

---

## Question 7 | ServiceAccount, Role, and RoleBinding (8 points)

> Server: `ssh ckad9999`

```bash
# Step 1: Create ServiceAccount
kubectl create sa log-sa -n marsh

# Step 2: Create Role
kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: log-role
  namespace: marsh
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list", "watch"]
EOF

# Step 3: Create RoleBinding
kubectl create rolebinding log-rb \
  --role=log-role \
  --serviceaccount=marsh:log-sa \
  -n marsh

# Step 4: Update Pod to use ServiceAccount
kubectl get pod log-collector -n marsh -o yaml > /tmp/log-collector.yaml
# Edit /tmp/log-collector.yaml to add:  spec.serviceAccountName: log-sa
kubectl delete pod log-collector -n marsh
kubectl apply -f /tmp/log-collector.yaml

# Verify
kubectl get pod log-collector -n marsh
kubectl logs log-collector -n marsh
```

---

## Question 8 | Perform Rolling Update and Rollback (8 points)

> Server: `ssh ckad9988`

```bash
# Step 1: Update the image
kubectl set image deploy/app-v1 nginx=nginx:1.25 -n brook

# Step 2: Monitor the rollout
kubectl rollout status deploy app-v1 -n brook

# Step 3: View rollout history
kubectl rollout history deploy app-v1 -n brook

# Step 4: Rollback to previous revision
kubectl rollout undo deploy app-v1 -n brook

# Step 5: Verify rollback (image should be nginx:1.20)
kubectl rollout status deploy app-v1 -n brook
kubectl get deploy app-v1 -n brook -o jsonpath='{.spec.template.spec.containers[0].image}'

# Step 6: Save current revision number
mkdir -p /tmp/exam/course/8
kubectl rollout history deploy app-v1 -n brook | tail -1 | awk '{print $1}' > /tmp/exam/course/8/rollback-revision.txt
```

---

## Question 9 | Build Container Image and Save as Tarball (8 points)

> Server: `ssh ckad9999`

```bash
# Step 1: Build the image
cd /tmp/exam/course/9/image
docker build -t my-app:1.0 .

# Verify
docker images | grep my-app

# Step 2: Save image as tarball
docker save -o /tmp/exam/course/9/my-app.tar my-app:1.0

# Verify
ls -lh /tmp/exam/course/9/my-app.tar
```

---

## Question 10 | Add Readiness Probe to Deployment (4 points)

> Server: `ssh ckad9988`

```bash
kubectl edit deploy api-deploy -n rapids
```

Add readiness probe under the `api` container:

```yaml
spec:
  template:
    spec:
      containers:
        - name: api
          readinessProbe:
            httpGet:
              path: /ready
              port: 8080
            initialDelaySeconds: 5
            periodSeconds: 10
```

```bash
# Verify
kubectl rollout status deploy api-deploy -n rapids
kubectl describe deploy api-deploy -n rapids
```

---

## Question 11 | Canary Deployment with Manual Traffic Split (8 points)

> Server: `ssh ckad9999`

```bash
# Step 1: Scale existing Deployment
kubectl scale deploy web-app --replicas=8 -n default

# Step 2: Create canary Deployment
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app-canary
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: webapp
      version: v2
  template:
    metadata:
      labels:
        app: webapp
        version: v2
    spec:
      containers:
        - name: web
          image: nginx:latest
          ports:
            - containerPort: 80
EOF

# Step 3: Verify Service selects both
kubectl get endpoints web-service -n default
kubectl get pods -n default -l app=webapp --show-labels
```

---

## Question 12 | Create Ingress Resource (4 points)

> Server: `ssh ckad9977`

```bash
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  namespace: eddy
spec:
  rules:
    - host: web.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: web-svc
                port:
                  number: 8080
EOF

# Verify
kubectl get ingress web-ingress -n eddy
kubectl describe ingress web-ingress -n eddy
```

---

## Question 13 | Pod Topology Spread Constraints (3 points) — Preview

> Server: `ssh ckad9999`

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: spread-pod
  namespace: eddy
  labels:
    app: spread
spec:
  topologySpreadConstraints:
    - maxSkew: 1
      topologyKey: kubernetes.io/hostname
      whenUnsatisfiable: DoNotSchedule
      labelSelector:
        matchLabels:
          app: spread
  containers:
    - name: nginx
      image: nginx
EOF

# Verify
kubectl get pod spread-pod -n eddy
kubectl describe pod spread-pod -n eddy
```

---

## Question 14 | Configure Pod and Container Security Context (6 points)

> Server: `ssh ckad9988`

```bash
kubectl edit deploy secure-app -n cascade
```

Add security contexts:

```yaml
spec:
  template:
    spec:
      securityContext:
        runAsUser: 1000
      containers:
        - name: app
          securityContext:
            capabilities:
              add:
                - NET_ADMIN
```

```bash
# Verify
kubectl rollout status deploy secure-app -n cascade
kubectl get pod -n cascade -l app=secure-app -o yaml | grep -A 10 securityContext
```

---

## Question 15 | Fix Ingress PathType (4 points)

> Server: `ssh ckad9977`

Edit `/tmp/exam/course/15/fix-ingress.yaml` — change `pathType: InvalidType` to a valid value (`Prefix`):

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-ingress
  namespace: default
spec:
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
```

```bash
# Apply
kubectl apply -f /tmp/exam/course/15/fix-ingress.yaml
kubectl get ingress api-ingress -n default
```

---

## Question 16 | Fix Service Selector (2 points)

> Server: `ssh ckad9988`

```bash
# Check current state
kubectl get pods -n shoal --show-labels
kubectl get endpoints web-svc -n shoal

# Fix selector
kubectl edit svc web-svc -n shoal
```

Change selector to:

```yaml
spec:
  selector:
    app: webapp
```

```bash
# Verify
kubectl get endpoints web-svc -n shoal
```

---

## Question 17 | Add Resource Requests and Limits to Pod (4 points)

> Server: `ssh ckad9977`

The `pond-quota` ResourceQuota sets `limits.cpu: "2"` and `limits.memory: "4Gi"`, so use half: `cpu: "1"` and `memory: "2Gi"` for limits.

```bash
# Step 1: Check ResourceQuota
kubectl get quota -n pond
kubectl describe quota pond-quota -n pond

# Step 2: Create Pod with half the quota limits
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: resource-pod
  namespace: pond
spec:
  containers:
    - name: web
      image: nginx:latest
      resources:
        requests:
          cpu: "100m"
          memory: "128Mi"
        limits:
          cpu: "1"
          memory: "2Gi"
EOF

# Verify
kubectl get pod resource-pod -n pond
kubectl describe pod resource-pod -n pond
```
