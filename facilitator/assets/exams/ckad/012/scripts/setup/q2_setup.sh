#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace fortress --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - >/dev/null 2>&1 <<'EOF' || true
apiVersion: v1
kind: Pod
metadata:
  name: webapp
  namespace: fortress
  labels:
    app: webapp
spec:
  containers:
  - name: webapp
    image: nginx:1.25
    ports:
    - containerPort: 80
    env:
    - name: DB_USER
      value: "admin"
    - name: DB_PASS
      value: "secret123"
EOF
echo "Setup complete for Question 2"
exit 0
