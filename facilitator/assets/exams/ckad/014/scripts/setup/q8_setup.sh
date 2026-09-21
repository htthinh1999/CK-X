#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

kubectl create namespace dusk --dry-run=client -o yaml | kubectl apply -f - || true

mkdir -p /tmp/exam/course/8
cat > /tmp/exam/course/8/deployment.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: web
        image: nginx:alpine
EOF

cat > /tmp/exam/course/8/kustomization.yaml <<'EOF'
resources:
  - deployment.yaml
# Add patch below
EOF

echo "Setup complete for Question 8"
exit 0
