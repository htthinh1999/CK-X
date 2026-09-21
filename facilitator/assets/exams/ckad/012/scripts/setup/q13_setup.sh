#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace citadel --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - >/dev/null 2>&1 <<'EOF' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-server
  namespace: citadel
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web-server
  template:
    metadata:
      labels:
        app: web-server
    spec:
      containers:
      - name: web-server
        image: nginx:1.24
        ports:
        - containerPort: 80
EOF
mkdir -p /tmp/exam/course/13
kubectl rollout status deployment web-server -n citadel --timeout=90s >/dev/null 2>&1 || true
kubectl set image deployment/web-server web-server=nginx:1.25 -n citadel >/dev/null 2>&1 || true
kubectl rollout status deployment web-server -n citadel --timeout=90s >/dev/null 2>&1 || true
kubectl set image deployment/web-server web-server=nginx:broken-oni -n citadel >/dev/null 2>&1 || true
echo "Setup complete for Question 13"
exit 0
