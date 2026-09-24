#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace eden --dry-run=client -o yaml | kubectl apply -f - || true

# Pre-create the high-priority PriorityClass referenced by the quota scope
kubectl apply -f - <<'EOF'
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: high-priority
value: 1000000
globalDefault: false
description: "This priority class should be used for high priority service pods only."
EOF

echo "Setup complete for Question 4"
exit 0
