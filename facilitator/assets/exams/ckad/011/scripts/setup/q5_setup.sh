#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

# Prerequisite: deployment history-deploy with at least 3 revisions.
kubectl create namespace wave --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

kubectl apply -f - >/dev/null 2>&1 <<'EOF' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: history-deploy
  namespace: wave
  annotations:
    kubernetes.io/change-cause: "Initial deployment with nginx:1.18"
spec:
  replicas: 2
  selector:
    matchLabels:
      app: history-deploy
  template:
    metadata:
      labels:
        app: history-deploy
    spec:
      containers:
      - name: nginx
        image: nginx:1.18
        ports:
        - containerPort: 80
EOF

kubectl set image deployment/history-deploy nginx=nginx:1.19 -n wave --record >/dev/null 2>&1 || true
kubectl rollout status deployment/history-deploy -n wave --timeout=60s >/dev/null 2>&1 || true
kubectl set image deployment/history-deploy nginx=nginx:1.20 -n wave --record >/dev/null 2>&1 || true
kubectl rollout status deployment/history-deploy -n wave --timeout=60s >/dev/null 2>&1 || true

mkdir -p /tmp/exam/course/5 || true

echo "Setup complete for Question 5"
exit 0
