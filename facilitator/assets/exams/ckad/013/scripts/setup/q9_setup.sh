#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace eclipse --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - >/dev/null 2>&1 <<'EOF' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: slow-app
  namespace: eclipse
spec:
  replicas: 1
  selector:
    matchLabels:
      app: slow
  template:
    metadata:
      labels:
        app: slow
    spec:
      containers:
        - name: app
          image: nginx:1.25
          ports:
            - containerPort: 8080
EOF
echo "Setup complete for Question 9"
exit 0
