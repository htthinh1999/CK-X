#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace refuge --dry-run=client -o yaml | kubectl apply -f - || true
kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
  namespace: refuge
spec:
  replicas: 5
  selector:
    matchLabels:
      app: api-server
  template:
    metadata:
      labels:
        app: api-server
    spec:
      containers:
      - name: api
        image: nginx:alpine
        resources:
          requests:
            cpu: 100m
---
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: api-hpa
  namespace: refuge
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: wrong-deployment
  minReplicas: 1
  maxReplicas: 5
  targetCPUUtilizationPercentage: 50
YAML
echo "Setup complete for Question 6"
exit 0
