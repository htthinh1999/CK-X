#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

kubectl create namespace magma --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
kubectl apply -f - <<'EOF' || true
apiVersion: v1
kind: ServiceAccount
metadata:
  name: fire-sa
  namespace: magma
  labels:
    exam: ckad-simulation1
automountServiceAccountToken: false
EOF

echo "Setup complete for Question 16"
exit 0
