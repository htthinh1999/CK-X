#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace flash --dry-run=client -o yaml | kubectl apply -f - || true
kubectl delete pod data-processor -n flash --ignore-not-found=true >/dev/null 2>&1 || true
kubectl apply -f - <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: data-processor
  namespace: flash
spec:
  containers:
  - name: processor
    image: busybox
    command: ["sh", "-c", "echo Starting...; sleep 2; exit 1"]
YAML
echo "Setup complete for Question 10"
exit 0
