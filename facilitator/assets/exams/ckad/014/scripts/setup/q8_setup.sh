#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace starlight --dry-run=client -o yaml | kubectl apply -f - || true

# Broken pod (misspelled image) - this is a fix-it question, so pre-create it broken.
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: metrics-gatherer
  namespace: starlight
spec:
  containers:
  - name: gatherer
    image: nginxxxxx:alpine
EOF

echo "Setup complete for Question 8"
exit 0
