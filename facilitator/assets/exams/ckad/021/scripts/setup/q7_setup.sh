#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace bastion --dry-run=client -o yaml | kubectl apply -f - || true
kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: worker-deploy
  namespace: bastion
spec:
  replicas: 1
  selector:
    matchLabels:
      app: worker
  template:
    metadata:
      labels:
        app: worker
    spec:
      containers:
      - name: nginx
        image: nginx:1.24.0
      - name: redis
        image: redis:6.2
YAML
echo "Setup complete for Question 7"
exit 0
