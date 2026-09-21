#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

kubectl create namespace vanguard --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/8
cat > /tmp/exam/course/8/kustomization.yaml <<'EOF'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- deployment.yaml
EOF
cat > /tmp/exam/course/8/deployment.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: vanguard-web
  namespace: vanguard
spec:
  replicas: 2
  selector:
    matchLabels:
      app: vanguard-web
  template:
    metadata:
      labels:
        app: vanguard-web
    spec:
      containers:
      - name: nginx
        image: nginx:1.21.0-alpine
EOF

echo "Setup complete for Question 8"
exit 0
