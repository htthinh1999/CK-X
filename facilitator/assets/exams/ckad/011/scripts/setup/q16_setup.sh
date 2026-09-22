#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

# Prerequisite: deployment web-deploy with multiple revisions (student rolls back to rev 2).
kubectl create namespace tide --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

kubectl apply -f - >/dev/null 2>&1 <<'EOF' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deploy
  namespace: tide
  annotations:
    kubernetes.io/change-cause: "Initial deployment with nginx:1.18"
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web-deploy
  template:
    metadata:
      labels:
        app: web-deploy
    spec:
      containers:
      - name: nginx
        image: nginx:1.18
        ports:
        - containerPort: 80
EOF

# Create additional revisions (revisions 2 and 3) so student can undo to revision 2.
kubectl set image deployment/web-deploy nginx=nginx:1.19 -n tide --record >/dev/null 2>&1 || true
kubectl rollout status deployment/web-deploy -n tide --timeout=60s >/dev/null 2>&1 || true
kubectl set image deployment/web-deploy nginx=nginx:1.20 -n tide --record >/dev/null 2>&1 || true
kubectl rollout status deployment/web-deploy -n tide --timeout=60s >/dev/null 2>&1 || true

echo "Setup complete for Question 16"
exit 0
