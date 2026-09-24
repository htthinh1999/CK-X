#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX create namespace alpha --dry-run=client -o yaml | kubectl $CTX apply -f - || true
# Broken deployment (image does not exist) the student must repair.
kubectl $CTX -n alpha apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: legacy
  namespace: alpha
spec:
  replicas: 2
  selector:
    matchLabels:
      app: legacy
  template:
    metadata:
      labels:
        app: legacy
    spec:
      containers:
        - name: app
          image: nginx:nope999
YAML
echo "Setup complete for Question 12"
exit 0
