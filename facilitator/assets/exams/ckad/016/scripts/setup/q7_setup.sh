#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace spark --dry-run=client -o yaml | kubectl apply -f - || true
kubectl delete deployment backend-v2 -n spark --ignore-not-found=true >/dev/null 2>&1 || true
kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-v1
  namespace: spark
spec:
  replicas: 4
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: nginx
        image: nginx:1.22
---
apiVersion: v1
kind: Service
metadata:
  name: backend-svc
  namespace: spark
spec:
  selector:
    app: backend
  ports:
  - port: 80
    targetPort: 80
YAML
echo "Setup complete for Question 7"
exit 0
