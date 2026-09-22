#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace nightfall --dry-run=client -o yaml | kubectl apply -f - || true

kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: critical-processor
  namespace: nightfall
spec:
  replicas: 2
  selector:
    matchLabels:
      app: critical
  template:
    metadata:
      labels:
        app: critical
    spec:
      containers:
      - name: app
        image: nginx:1.24
EOF

# Trigger a rollout update so there is an in-progress rollout to pause.
kubectl set image deployment/critical-processor app=nginx:1.25 -n nightfall 2>/dev/null || true

echo "Setup complete for Question 7"
exit 0
