#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace aria --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
kubectl delete pod heavy-worker -n aria --ignore-not-found=true 2>/dev/null || true
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: heavy-worker
  namespace: aria
spec:
  containers:
  - name: main
    image: busybox
    command: ["sleep", "3600"]
EOF
mkdir -p /tmp/exam/course/5
echo "Setup complete for Question 5"
exit 0
