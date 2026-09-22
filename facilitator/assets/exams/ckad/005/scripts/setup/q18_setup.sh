#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace fang --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - >/dev/null 2>&1 <<'YAML' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: safe-deploy
  namespace: fang
  labels:
    app: safe-deploy
    exam: ckad-simulation3
spec:
  replicas: 3
  selector:
    matchLabels:
      app: safe-deploy
  template:
    metadata:
      labels:
        app: safe-deploy
    spec:
      containers:
      - name: nginx
        image: nginx:1.21
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
          limits:
            memory: "128Mi"
            cpu: "200m"
YAML
echo "Setup complete for Question 18"
exit 0
