#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace strike --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/12
rm -f /tmp/exam/course/12/events.txt 2>/dev/null || true
kubectl apply -f - <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: broken-pod
  namespace: strike
spec:
  containers:
  - name: broken
    image: non-existent-image-12345
YAML
echo "Setup complete for Question 12"
exit 0
