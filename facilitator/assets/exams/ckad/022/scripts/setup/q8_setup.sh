#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace mastery --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/8/base /tmp/exam/course/8/prod
cat > /tmp/exam/course/8/base/deployment.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: web
        image: nginx
EOF
cat > /tmp/exam/course/8/base/kustomization.yaml <<'EOF'
resources:
- deployment.yaml
EOF
echo "Setup complete for Question 8"
exit 0
