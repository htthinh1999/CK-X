#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace glory --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/6
kubectl apply -f - <<'EOF' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: glory-deploy
  namespace: glory
spec:
  replicas: 3
  selector:
    matchLabels:
      app: glory
  template:
    metadata:
      labels:
        app: glory
    spec:
      containers:
      - name: nginx
        image: nginx:1.24
EOF
echo "Setup complete for Question 6"
exit 0
