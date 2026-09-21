#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace lyric --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
kubectl delete deployment app-deploy -n lyric --ignore-not-found=true 2>/dev/null || true
mkdir -p /tmp/exam/course/8/base
cat > /tmp/exam/course/8/base/kustomization.yaml <<'EOF'
resources:
  - deployment.yaml
EOF
cat > /tmp/exam/course/8/base/deployment.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-deploy
spec:
  replicas: 2
  selector:
    matchLabels:
      app: test
  template:
    metadata:
      labels:
        app: test
    spec:
      containers:
      - name: main
        image: nginx:alpine
EOF
mkdir -p /tmp/exam/course/8/overlays/production
cat > /tmp/exam/course/8/kustomization.yaml <<'EOF'
# TODO: Complete Kustomize config
EOF
echo "Setup complete for Question 8"
exit 0
