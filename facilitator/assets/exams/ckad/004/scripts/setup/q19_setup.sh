#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace ares --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

mkdir -p /tmp/exam/course/19
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: battle-app
  namespace: ares
spec:
  replicas: 3
  selector:
    matchLabels:
      app: battle-app
  template:
    metadata:
      labels:
        app: battle-app
    spec:
      containers:
      - name: nginx
        image: nginx:1.20
        ports:
        - containerPort: 80
EOF
echo "Setup complete for Question 19"
exit 0
