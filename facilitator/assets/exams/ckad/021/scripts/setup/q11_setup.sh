#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace helm --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/11
kubectl apply -f - <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: backend-pod-1
  namespace: helm
  labels:
    tier: backend
spec:
  containers:
  - name: c
    image: nginx:alpine
---
apiVersion: v1
kind: Pod
metadata:
  name: backend-pod-2
  namespace: helm
  labels:
    tier: backend
spec:
  containers:
  - name: c
    image: nginx:alpine
YAML
echo "Setup complete for Question 11"
exit 0
