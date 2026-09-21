#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace breeze --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: v1
kind: ServiceAccount
metadata:
  name: breeze-admin
  namespace: breeze
EOF
echo "Setup complete for Question 13"
exit 0
