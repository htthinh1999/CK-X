#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace garrison --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - >/dev/null 2>&1 <<'EOF' || true
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: garrison
spec:
  hard:
    requests.cpu: "500m"
    requests.memory: "512Mi"
    limits.cpu: "1"
    limits.memory: "1Gi"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: quota-app
  namespace: garrison
spec:
  replicas: 1
  selector:
    matchLabels:
      app: quota-app
  template:
    metadata:
      labels:
        app: quota-app
    spec:
      containers:
      - name: quota-app
        image: nginx:1.25
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: "1"
            memory: "1Gi"
          limits:
            cpu: "2"
            memory: "2Gi"
EOF
echo "Setup complete for Question 18"
exit 0
