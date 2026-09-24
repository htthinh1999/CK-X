#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace gate --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - >/dev/null 2>&1 <<'EOF' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-app
  namespace: gate
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend-app
  template:
    metadata:
      labels:
        app: backend-app
    spec:
      containers:
      - name: backend-app
        image: nginx:1.25
        ports:
        - containerPort: 80
EOF
echo "Setup complete for Question 12"
exit 0
