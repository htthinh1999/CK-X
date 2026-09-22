# CKAD Simulation 6 — Answers

> Dojo Tengu 👺 — 「天狗は山を守る」 The tengu guards the mountain
>
> Total Score: 106 points | Passing Score: ~66%
>
> Original Questions: Adapted from [CKAD-exercises](https://github.com/dgkanatsios/CKAD-exercises) by [@dgkanatsios](https://github.com/dgkanatsios)
>
> Each question runs on the server shown under its heading: `ssh` to that host and use its default context (one cluster per host). File paths use `/tmp/exam/course/...`.

---

## Question 1 | Namespace and Pod Creation (4 points)

> Server: `ssh ckad9999`

```bash
kubectl create namespace mynamespace
kubectl run nginx --image=nginx:1.25 --restart=Never -n mynamespace
```

Or using YAML:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  namespace: mynamespace
spec:
  containers:
  - name: nginx
    image: nginx:1.25
  restartPolicy: Never
```

---

## Question 2 | Pod with Environment Variables (5 points)

> Server: `ssh ckad9999`

```bash
kubectl run envpod --image=busybox:1.36 --restart=Never -n summit --env=VAR1=value1 -- env
```

Or using YAML:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: envpod
  namespace: summit
spec:
  containers:
  - name: envpod
    image: busybox:1.36
    command: ["env"]
    env:
    - name: VAR1
      value: "value1"
  restartPolicy: Never
```

---

## Question 3 | ResourceQuota (6 points)

> Server: `ssh ckad9999`

```bash
kubectl create quota cliff-quota -n cliff --hard=cpu=1,memory=1G,pods=2
```

Or using YAML:

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: cliff-quota
  namespace: cliff
spec:
  hard:
    cpu: "1"
    memory: 1G
    pods: "2"
```

---

## Question 4 | Labels and Selectors (5 points)

> Server: `ssh ckad9999`

```bash
# Create 3 pods with label app=v1
kubectl run nginx1 --image=nginx:1.25 --restart=Never -n ridge --labels=app=v1
kubectl run nginx2 --image=nginx:1.25 --restart=Never -n ridge --labels=app=v1
kubectl run nginx3 --image=nginx:1.25 --restart=Never -n ridge --labels=app=v1

# Change nginx2 label to app=v2
kubectl label po nginx2 -n ridge app=v2 --overwrite

# Add tier=web to pods with app=v1 (nginx1 and nginx3)
kubectl label po -n ridge -l app=v1 tier=web
```

---

## Question 5 | Deployment Creation (6 points)

> Server: `ssh ckad9999`

```bash
kubectl create deployment nginx-deploy --image=nginx:1.18.0 --replicas=2 --port=80 -n valley
```

Or using YAML:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
  namespace: valley
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx-deploy
  template:
    metadata:
      labels:
        app: nginx-deploy
    spec:
      containers:
      - name: nginx
        image: nginx:1.18.0
        ports:
        - containerPort: 80
```

---

## Question 6 | Deployment Rollout (5 points)

> Server: `ssh ckad9999`

```bash
# Update the image
kubectl set image deployment/nginx-deploy nginx=nginx:1.19.8 -n valley

# Verify the rollout completed
kubectl rollout status deployment/nginx-deploy -n valley

# Check the rollout history
kubectl rollout history deployment/nginx-deploy -n valley
```

---

## Question 7 | Deployment Rollback (5 points)

> Server: `ssh ckad9999`

The `rollback-deploy` Deployment in `cave` was updated to a broken image (`nginx:1.91`) creating a failing revision. Roll it back to the previous working revision.

```bash
# Observe the failing rollout
kubectl rollout status deployment/rollback-deploy -n cave

# Roll back to the previous revision
kubectl rollout undo deployment/rollback-deploy -n cave

# Verify pods are running again
kubectl get pods -n cave -l app=rollback-deploy
```

---

## Question 8 | Job with Completions (5 points)

> Server: `ssh ckad9988`

```bash
kubectl create job echo-job --image=busybox:1.36 -n stone --dry-run=client -o yaml \
  -- /bin/sh -c 'echo hello; sleep 5; echo world' > /tmp/exam/echo-job.yaml
```

Edit to add `completions: 5`:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: echo-job
  namespace: stone
spec:
  completions: 5
  template:
    spec:
      containers:
      - name: echo-job
        image: busybox:1.36
        command: ["/bin/sh", "-c", "echo hello; sleep 5; echo world"]
      restartPolicy: Never
```

```bash
kubectl apply -f /tmp/exam/echo-job.yaml
```

---

## Question 9 | CronJob (5 points)

> Server: `ssh ckad9988`

```bash
kubectl create cronjob date-job --image=busybox:1.36 --schedule="*/1 * * * *" -n mist \
  -- /bin/sh -c 'date; echo Hello from Kubernetes'
```

---

## Question 10 | Multi-Container Pod (6 points)

> Server: `ssh ckad9988`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: multi-container
  namespace: alpine
spec:
  containers:
  - name: container1
    image: busybox:1.36
    command: ["/bin/sh", "-c", "echo hello; sleep 3600"]
  - name: container2
    image: busybox:1.36
    command: ["/bin/sh", "-c", "echo hello; sleep 3600"]
```

---

## Question 11 | Init Container (6 points)

> Server: `ssh ckad9988`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: init-pod
  namespace: crest
spec:
  initContainers:
  - name: init
    image: busybox:1.36
    command: ["/bin/sh", "-c", "echo 'Initialized' > /work-dir/index.html"]
    volumeMounts:
    - name: workdir
      mountPath: /work-dir
  containers:
  - name: nginx
    image: nginx:1.25
    ports:
    - containerPort: 80
    volumeMounts:
    - name: workdir
      mountPath: /usr/share/nginx/html
  volumes:
  - name: workdir
    emptyDir: {}
```

---

## Question 12 | ConfigMap from Literals (4 points)

> Server: `ssh ckad9988`

```bash
kubectl create configmap app-config --from-literal=foo=lala --from-literal=foo2=lolo -n peak
```

---

## Question 13 | ConfigMap as Environment Variable (5 points)

> Server: `ssh ckad9988`

```bash
kubectl create configmap options --from-literal=var5=val5 -n summit
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: config-pod
  namespace: summit
spec:
  containers:
  - name: nginx
    image: nginx:1.25
    env:
    - name: OPTION
      valueFrom:
        configMapKeyRef:
          name: options
          key: var5
```

---

## Question 14 | ConfigMap as Volume (5 points)

> Server: `ssh ckad9988`

```bash
kubectl create configmap cmvolume --from-literal=var8=val8 --from-literal=var9=val9 -n cliff
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: vol-pod
  namespace: cliff
spec:
  containers:
  - name: nginx
    image: nginx:1.25
    volumeMounts:
    - name: config-volume
      mountPath: /etc/lala
  volumes:
  - name: config-volume
    configMap:
      name: cmvolume
```

---

## Question 15 | Secret Creation and Usage (5 points)

> Server: `ssh ckad9977`

```bash
kubectl create secret generic mysecret --from-literal=password=mypass -n ridge
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-pod
  namespace: ridge
spec:
  containers:
  - name: nginx
    image: nginx:1.25
    volumeMounts:
    - name: secret-volume
      mountPath: /etc/foo
  volumes:
  - name: secret-volume
    secret:
      secretName: mysecret
```

---

## Question 16 | SecurityContext (5 points)

> Server: `ssh ckad9977`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-pod
  namespace: valley
spec:
  securityContext:
    runAsUser: 101
  restartPolicy: Never
  containers:
  - name: secure-pod
    image: busybox:1.36
    command: ["sleep", "3600"]
```

Note: `busybox` is used instead of `nginx` because the standard nginx image needs root privileges to create its cache directories.

---

## Question 17 | Resource Requests and Limits (5 points)

> Server: `ssh ckad9977`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: resource-pod
  namespace: cave
spec:
  containers:
  - name: nginx
    image: nginx:1.25
    resources:
      requests:
        cpu: "100m"
        memory: "256Mi"
      limits:
        cpu: "200m"
        memory: "512Mi"
```

---

## Question 18 | Liveness Probe (5 points)

> Server: `ssh ckad9977`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: liveness-pod
  namespace: stone
spec:
  containers:
  - name: nginx
    image: nginx:1.25
    livenessProbe:
      exec:
        command:
        - ls
      initialDelaySeconds: 5
      periodSeconds: 5
```

---

## Question 19 | Service and NetworkPolicy (6 points)

> Server: `ssh ckad9977`

```bash
kubectl create deployment web --image=nginx:1.25 --replicas=2 -n mist
kubectl expose deployment web --port=80 --type=ClusterIP -n mist
```

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: web-policy
  namespace: mist
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
          access: granted
```

---

## Question 20 | PersistentVolume and PersistentVolumeClaim (8 points)

> Server: `ssh ckad9977`

```yaml
# PersistentVolume (cluster-scoped)
apiVersion: v1
kind: PersistentVolume
metadata:
  name: myvolume
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
    - ReadWriteMany
  storageClassName: normal
  hostPath:
    path: /etc/foo
---
# PersistentVolumeClaim
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mypvc
  namespace: alpine
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: normal
  resources:
    requests:
      storage: 4Gi
---
# Pod using the PVC
apiVersion: v1
kind: Pod
metadata:
  name: pv-pod
  namespace: alpine
spec:
  containers:
  - name: busybox
    image: busybox:1.36
    command: ["sleep", "3600"]
    volumeMounts:
    - name: pv-storage
      mountPath: /etc/foo
  volumes:
  - name: pv-storage
    persistentVolumeClaim:
      claimName: mypvc
```
