#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace blaze --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
mkdir -p /tmp/exam/course/9
kubectl apply -f - <<'EOF' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: stable-v1
  namespace: blaze
  labels:
    app: web-frontend
    version: v1
    exam: ckad-simulation1
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-frontend
      version: v1
  template:
    metadata:
      labels:
        app: web-frontend
        version: v1
    spec:
      containers:
      - name: nginx
        image: nginx:1.21
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
          limits:
            memory: "128Mi"
            cpu: "200m"
EOF
cat > /tmp/exam/course/9/canary.yaml <<'EOF'
# Q9 - Canary Deployment Template
# Task: Create a canary deployment alongside stable-v1
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: canary-v2
  namespace: blaze
  labels:
    app: web-frontend
    version: v2
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web-frontend
      version: v2
  template:
    metadata:
      labels:
        app: web-frontend
        version: v2
    spec:
      containers:
      - name: nginx
        image: nginx:1.22
        ports:
        - containerPort: 80
EOF

echo "Setup complete for Question 9"
exit 0
