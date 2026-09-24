#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace shoal --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  namespace: shoal
spec:
  replicas: 2
  selector:
    matchLabels:
      app: webapp
      tier: frontend
  template:
    metadata:
      labels:
        app: webapp
        tier: frontend
    spec:
      containers:
        - name: web
          image: nginx:alpine
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: web-svc
  namespace: shoal
spec:
  selector:
    app: wrongapp
  ports:
    - port: 80
      targetPort: 80
EOF
echo "Setup complete for Question 16"
exit 0
