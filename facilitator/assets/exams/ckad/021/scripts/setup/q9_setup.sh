#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace anchor --dry-run=client -o yaml | kubectl apply -f - || true
kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: broken-app
  namespace: anchor
spec:
  replicas: 1
  selector:
    matchLabels:
      app: broken
  template:
    metadata:
      labels:
        app: broken
    spec:
      containers:
      - name: app
        image: ngnx:latest
        ports:
        - containerPort: 8080
        env:
        - name: PASSWORD
          valueFrom:
            secretKeyRef:
              name: app-secret
              key: PASSWORD
YAML
echo "Setup complete for Question 9"
exit 0
