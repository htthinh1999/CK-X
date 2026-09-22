#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace pier --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# The student creates this policy
kubectl -n pier delete networkpolicy berth-db-access --ignore-not-found=true >/dev/null 2>&1 || true

cat <<'YAML' | kubectl apply -f - >/dev/null 2>&1 || true
apiVersion: v1
kind: Pod
metadata:
  name: gate-ui
  namespace: pier
  labels:
    app: pier
    tier: frontend
spec:
  containers:
    - name: web
      image: nginx:1.25
      ports:
        - containerPort: 80
---
apiVersion: v1
kind: Pod
metadata:
  name: dispatch-api
  namespace: pier
  labels:
    app: pier
    tier: backend
spec:
  containers:
    - name: api
      image: busybox:1.36
      command: ["sh", "-c", "sleep 86400"]
---
apiVersion: v1
kind: Pod
metadata:
  name: berth-db
  namespace: pier
  labels:
    app: pier
    tier: db
spec:
  containers:
    - name: redis
      image: redis:7-alpine
      ports:
        - containerPort: 6379
YAML

echo "Setup complete for Question 16"
exit 0
