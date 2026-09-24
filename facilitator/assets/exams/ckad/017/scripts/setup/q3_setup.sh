#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace reef --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - >/dev/null 2>&1 <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: target-pod
  namespace: reef
spec:
  containers:
  - name: web
    image: nginx:alpine
EOF
echo "Setup complete for Question 3"
exit 0
