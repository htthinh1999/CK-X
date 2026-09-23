#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=capacity
D=/home/candidate/exam/q11

kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

rm -rf "$D"
mkdir -p "$D"

# Reset: remove what a previous attempt may have changed
kubectl -n "$NS" delete deployment load-planner load-reporter load-dashboard --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl -n "$NS" delete pod load-probe --ignore-not-found --grace-period=0 --force >/dev/null 2>&1 || true

cat <<'YAML' | kubectl apply -f - >/dev/null
apiVersion: apps/v1
kind: Deployment
metadata:
  name: load-planner
  namespace: capacity
spec:
  replicas: 3
  selector:
    matchLabels:
      app: load-planner
  template:
    metadata:
      labels:
        app: load-planner
    spec:
      containers:
      - name: planner
        image: nginx:1.25
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 250m
            memory: 256Mi
      - name: cache
        image: redis:7-alpine
        resources:
          requests:
            cpu: 50m
            memory: 750Gi
          limits:
            cpu: 100m
            memory: 750Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: load-reporter
  namespace: capacity
spec:
  replicas: 2
  selector:
    matchLabels:
      app: load-reporter
  template:
    metadata:
      labels:
        app: load-reporter
    spec:
      containers:
      - name: report
        image: nginx:1.25
        resources:
          requests:
            cpu: "400"
            memory: 64Mi
          limits:
            cpu: "400"
            memory: 64Mi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: load-dashboard
  namespace: capacity
spec:
  replicas: 1
  selector:
    matchLabels:
      app: load-dashboard
  template:
    metadata:
      labels:
        app: load-dashboard
    spec:
      containers:
      - name: dashboard
        image: nginx:1.25
        resources:
          requests:
            cpu: 20m
            memory: 32Mi
---
apiVersion: v1
kind: Pod
metadata:
  name: load-probe
  namespace: capacity
  labels:
    app: load-probe
spec:
  nodeSelector:
    transit.example.com/pool: gpu
  containers:
  - name: probe
    image: busybox:1.36
    command: ["sh", "-c", "sleep 36000"]
    resources:
      requests:
        cpu: 10m
        memory: 16Mi
YAML

echo "Setup complete for Question 11"
exit 0
