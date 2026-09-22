#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX create namespace prod --dry-run=client -o yaml | kubectl $CTX apply -f - || true
kubectl $CTX -n prod delete ingress shop-ing --ignore-not-found=true
# Backend the student's Ingress routes to (independent prerequisite).
kubectl $CTX -n prod apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: shop
  namespace: prod
spec:
  replicas: 1
  selector:
    matchLabels:
      app: shop
  template:
    metadata:
      labels:
        app: shop
    spec:
      containers:
        - name: web
          image: nginx:1.25
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: shop-svc
  namespace: prod
spec:
  selector:
    app: shop
  ports:
    - port: 80
      targetPort: 80
YAML
echo "Setup complete for Question 10"; exit 0
