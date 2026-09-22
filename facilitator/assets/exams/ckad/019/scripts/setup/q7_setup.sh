#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace rampart --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/7
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server-blue
  namespace: rampart
spec:
  replicas: 2
  selector:
    matchLabels:
      app: api-server-blue
  template:
    metadata:
      labels:
        app: api-server-blue
    spec:
      containers:
      - name: nginx
        image: nginx:1.24.0-alpine
---
apiVersion: v1
kind: Service
metadata:
  name: api-svc
  namespace: rampart
spec:
  selector:
    app: api-server-blue
  ports:
  - port: 80
    targetPort: 80
EOF

echo "Setup complete for Question 7"
exit 0
