#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace field --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

mkdir -p /tmp/exam/course/16 || true
chown -R candidate:candidate /tmp/exam 2>/dev/null || true
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: v1
kind: Pod
metadata:
  name: web-backend
  namespace: field
  labels:
    app: web
spec:
  containers:
  - name: nginx
    image: nginx:1.25
    ports:
    - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: web-svc
  namespace: field
spec:
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 80
EOF

echo "Setup complete for Question 16"
exit 0
