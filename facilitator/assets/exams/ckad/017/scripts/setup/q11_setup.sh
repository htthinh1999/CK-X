#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace wave --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - >/dev/null 2>&1 <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: mesh-pod
  namespace: wave
  labels:
    app: mesh-app
spec:
  containers:
  - name: app
    image: nginx:alpine
---
apiVersion: v1
kind: Service
metadata:
  name: mesh-service
  namespace: wave
spec:
  ports:
  - port: 80
    targetPort: 80
  selector:
    app: wrong-label
EOF
echo "Setup complete for Question 11"
exit 0
