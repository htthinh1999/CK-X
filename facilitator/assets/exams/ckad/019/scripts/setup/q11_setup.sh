#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

kubectl create namespace armory --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: v1
kind: ResourceQuota
metadata:
  name: armory-quota
  namespace: armory
spec:
  hard:
    requests.cpu: "500m"
    requests.memory: "1Gi"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: weapon-smith
  namespace: armory
spec:
  replicas: 1
  selector:
    matchLabels:
      app: weapon-smith
  template:
    metadata:
      labels:
        app: weapon-smith
    spec:
      containers:
      - name: app
        image: nginx:alpine
        resources:
          requests:
            cpu: "200m"
            memory: "512Mi"
EOF

echo "Setup complete for Question 11"
exit 0
