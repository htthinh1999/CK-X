#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=junction
D=/home/candidate/exam/q2

kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

rm -rf "$D"
mkdir -p "$D"

# Reset: remove everything a previous attempt may have changed
kubectl -n "$NS" delete deployment junction-blue junction-green junction-smoke junction-ticker \
  --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl -n "$NS" delete service junction junction-preview --ignore-not-found >/dev/null 2>&1 || true
kubectl -n "$NS" delete pod junction-debug --ignore-not-found --grace-period=0 --force >/dev/null 2>&1 || true
kubectl -n "$NS" delete configmap junction-cutover --ignore-not-found >/dev/null 2>&1 || true

cat <<'YAML' | kubectl apply -f - >/dev/null
apiVersion: v1
kind: ConfigMap
metadata:
  name: junction-cutover
  namespace: junction
data:
  plan.txt: |
    1. bring green up to the size of blue
    2. move the junction Service to green
    3. drain blue (keep the Deployment for rollback)
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: junction-blue
  namespace: junction
  labels:
    app: junction
    slot: blue
spec:
  replicas: 4
  selector:
    matchLabels:
      app: junction
      tier: web
      slot: blue
  template:
    metadata:
      labels:
        app: junction
        tier: web
        slot: blue
    spec:
      containers:
      - name: web
        image: nginx:1.25
        ports:
        - name: http
          containerPort: 80
        resources:
          requests:
            cpu: 10m
            memory: 16Mi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: junction-green
  namespace: junction
  labels:
    app: junction
    slot: green
spec:
  replicas: 0
  selector:
    matchLabels:
      app: junction
      tier: web
      slot: green
  template:
    metadata:
      labels:
        app: junction
        tier: web
        slot: green
    spec:
      containers:
      - name: web
        image: nginx:1.26
        ports:
        - name: web
          containerPort: 80
        resources:
          requests:
            cpu: 10m
            memory: 16Mi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: junction-smoke
  namespace: junction
  labels:
    app: junction
    slot: green
    tier: smoke
spec:
  replicas: 1
  selector:
    matchLabels:
      app: junction
      tier: smoke
      slot: green
  template:
    metadata:
      labels:
        app: junction
        tier: smoke
        slot: green
    spec:
      containers:
      - name: web
        image: nginx:1.26
        ports:
        - name: http
          containerPort: 80
        resources:
          requests:
            cpu: 10m
            memory: 16Mi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: junction-ticker
  namespace: junction
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ticker
  template:
    metadata:
      labels:
        app: ticker
        tier: web
    spec:
      containers:
      - name: ticker
        image: busybox:1.36
        command: ["sh", "-c", "while true; do date; sleep 30; done"]
---
apiVersion: v1
kind: Pod
metadata:
  name: junction-debug
  namespace: junction
  labels:
    app: junction
    tier: debug
spec:
  containers:
  - name: shell
    image: busybox:1.36
    command: ["sh", "-c", "sleep 36000"]
---
apiVersion: v1
kind: Service
metadata:
  name: junction
  namespace: junction
spec:
  selector:
    app: junction
    tier: web
    slot: blue
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: http
---
apiVersion: v1
kind: Service
metadata:
  name: junction-preview
  namespace: junction
spec:
  selector:
    app: junction
    slot: green
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: 80
YAML

kubectl -n "$NS" rollout status deployment/junction-blue --timeout=120s >/dev/null 2>&1 || true

echo "Setup complete for Question 2"
exit 0
