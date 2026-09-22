#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace origin --dry-run=client -o yaml | kubectl apply -f - || true

# Pre-create the Secret and ConfigMap the projected volume references
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
  namespace: origin
stringData:
  username: admin
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-config
  namespace: origin
data:
  app.properties: "key=value"
EOF

echo "Setup complete for Question 12"
exit 0
