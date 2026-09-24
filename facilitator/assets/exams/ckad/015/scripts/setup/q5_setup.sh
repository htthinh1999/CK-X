#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace zephyr --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: v1
kind: Pod
metadata:
  name: zephyr-api
  namespace: zephyr
spec:
  containers:
  - name: api
    image: nginx:alpine
EOF
echo "Setup complete for Question 5"
exit 0
