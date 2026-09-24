#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace bark --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - <<'YAML' >/dev/null 2>&1 || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pause-deploy
  namespace: bark
spec:
  replicas: 2
  selector:
    matchLabels:
      app: pause-deploy
  template:
    metadata:
      labels:
        app: pause-deploy
    spec:
      containers:
      - name: nginx
        image: nginx:1.18.0
        ports:
        - containerPort: 80
YAML
echo "Setup complete for Question 9"
exit 0
