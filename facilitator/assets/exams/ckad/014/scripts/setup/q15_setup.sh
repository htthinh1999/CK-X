#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace crescent --dry-run=client -o yaml | kubectl apply -f - || true

kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Secret
metadata:
  name: db-creds
  namespace: crescent
type: Opaque
data:
  password: cGFzc3dvcmQxMjM=
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: crescent
data:
  color: blue
EOF

echo "Setup complete for Question 15"
exit 0
