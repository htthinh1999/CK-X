#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX create namespace staging --dry-run=client -o yaml | kubectl $CTX apply -f - || true
kubectl $CTX -n staging apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rollme
  namespace: staging
spec:
  replicas: 2
  selector:
    matchLabels:
      app: rollme
  template:
    metadata:
      labels:
        app: rollme
    spec:
      containers:
        - name: app
          image: nginx:1.24
YAML
echo "Setup complete for Question 7"; exit 0
