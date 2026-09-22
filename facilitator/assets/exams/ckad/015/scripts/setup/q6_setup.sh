#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace cyclone --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cyclone-web
  namespace: cyclone
spec:
  replicas: 2
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: cyclone-web
  template:
    metadata:
      labels:
        app: cyclone-web
    spec:
      containers:
      - name: web
        image: nginx:1.22
EOF
echo "Setup complete for Question 6"
exit 0
