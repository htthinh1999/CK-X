#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace pond --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: v1
kind: ResourceQuota
metadata:
  name: pond-quota
  namespace: pond
spec:
  hard:
    limits.cpu: "2"
    limits.memory: "4Gi"
    requests.cpu: "1"
    requests.memory: "2Gi"
    pods: "10"
EOF
echo "Setup complete for Question 16"
exit 0
