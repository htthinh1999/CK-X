#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX create namespace alpha --dry-run=client -o yaml | kubectl $CTX apply -f - || true
# Deployment the student must scale + reconfigure.
kubectl $CTX -n alpha apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: payments
  namespace: alpha
spec:
  replicas: 2
  selector:
    matchLabels:
      app: payments
  template:
    metadata:
      labels:
        app: payments
    spec:
      containers:
        - name: app
          image: nginx:1.25
YAML
echo "Setup complete for Question 4"
exit 0
