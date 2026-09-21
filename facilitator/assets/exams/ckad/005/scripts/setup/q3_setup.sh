#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace stripe --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - >/dev/null 2>&1 <<'YAML' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: stable-blue
  namespace: stripe
  labels:
    app: web-app
    version: blue
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
      version: blue
  template:
    metadata:
      labels:
        app: web-app
        version: blue
    spec:
      containers:
      - name: nginx
        image: nginx:1.21
        ports:
        - containerPort: 80
        env:
        - name: VERSION
          value: "blue"
---
apiVersion: v1
kind: Service
metadata:
  name: web-service
  namespace: stripe
spec:
  type: ClusterIP
  selector:
    app: web-app
    version: blue
  ports:
  - port: 80
    targetPort: 80
YAML
echo "Setup complete for Question 3"
exit 0
