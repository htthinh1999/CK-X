#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace sunbeam --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - >/dev/null 2>&1 <<'EOF' || true
apiVersion: v1
kind: Pod
metadata:
  name: api-server
  namespace: sunbeam
  labels:
    app: api
spec:
  containers:
    - name: api
      image: nginx:1.25
      ports:
        - containerPort: 80
---
apiVersion: v1
kind: Pod
metadata:
  name: web-frontend
  namespace: sunbeam
  labels:
    role: frontend
spec:
  containers:
    - name: web
      image: nginx:1.25
EOF
echo "Setup complete for Question 18"
exit 0
