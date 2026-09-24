#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace legacy --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/19
kubectl apply -f - <<'EOF' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: legacy-main
  namespace: legacy
spec:
  replicas: 2
  selector:
    matchLabels:
      app: legacy-web
  template:
    metadata:
      labels:
        app: legacy-web
    spec:
      containers:
      - name: web
        image: nginx
EOF
echo "Setup complete for Question 19"
exit 0
