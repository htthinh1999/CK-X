#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace parapet --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - >/dev/null 2>&1 <<'EOF' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: parapet
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend-api
  template:
    metadata:
      labels:
        app: backend-api
    spec:
      containers:
      - name: backend
        image: nginx:1.25
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: backend-svc
  namespace: parapet
spec:
  type: ClusterIP
  selector:
    app: backend-wrong
  ports:
  - port: 80
    targetPort: 80
EOF
echo "Setup complete for Question 3"
exit 0
