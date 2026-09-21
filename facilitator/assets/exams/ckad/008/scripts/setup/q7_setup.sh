#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

kubectl create namespace cave --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Pre-create working deployment (revision 1, nginx:1.19.10)
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rollback-deploy
  namespace: cave
spec:
  replicas: 2
  selector:
    matchLabels:
      app: rollback-deploy
  template:
    metadata:
      labels:
        app: rollback-deploy
    spec:
      containers:
      - name: nginx
        image: nginx:1.19.10
        ports:
        - containerPort: 80
EOF

kubectl rollout status deployment rollback-deploy -n cave --timeout=60s >/dev/null 2>&1 || true
# Introduce broken image to create revision 2 (the failing state the student must roll back)
kubectl set image deployment/rollback-deploy nginx=nginx:1.91 -n cave >/dev/null 2>&1 || true

echo "Setup complete for Question 7"
exit 0
