#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace wave --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
# Pre-create pods labeled tier: api that the NetworkPolicy will target (prerequisite per task narrative)
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-workload
  namespace: wave
  labels:
    tier: api
spec:
  replicas: 2
  selector:
    matchLabels:
      tier: api
  template:
    metadata:
      labels:
        tier: api
    spec:
      containers:
      - name: nginx
        image: nginx:1.21
        ports:
        - containerPort: 80
EOF
echo "Setup complete for Question 16"
exit 0
