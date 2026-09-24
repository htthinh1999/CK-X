#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace stream --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
  namespace: stream
spec:
  replicas: 1
  selector:
    matchLabels:
      app: api-server
  template:
    metadata:
      labels:
        app: api-server
    spec:
      containers:
        - name: api
          image: nginx:alpine
          ports:
            - containerPort: 80
          env:
            - name: DB_USER
              value: "admin"
            - name: DB_PASS
              value: "Secret123!"
EOF
echo "Setup complete for Question 2"
exit 0
