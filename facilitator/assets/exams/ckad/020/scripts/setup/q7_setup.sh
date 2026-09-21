#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

kubectl create namespace eden --dry-run=client -o yaml | kubectl apply -f - || true

# Pre-create the eden-api deployment on the old image nginx:1.20
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: eden-api
  namespace: eden
spec:
  replicas: 2
  selector:
    matchLabels:
      app: eden-api
  template:
    metadata:
      labels:
        app: eden-api
    spec:
      containers:
      - name: nginx
        image: nginx:1.20
EOF

echo "Setup complete for Question 7"
exit 0
