#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace wave --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - >/dev/null 2>&1 <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: backend-pod
  namespace: wave
spec:
  containers:
  - name: backend
    image: wrongregistry.k8s.io/nginx:alpine
EOF
echo "Setup complete for Question 5"
exit 0
