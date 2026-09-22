#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace melody --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
kubectl delete pod projected-pod -n melody --ignore-not-found=true 2>/dev/null || true
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: info-cm
  namespace: melody
data:
  info.txt: "config data"
---
apiVersion: v1
kind: Secret
metadata:
  name: info-secret
  namespace: melody
stringData:
  secret.txt: "secret data"
EOF
echo "Setup complete for Question 12"
exit 0
