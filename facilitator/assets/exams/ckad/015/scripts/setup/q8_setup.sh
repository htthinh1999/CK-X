#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace tornado --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/8
cat > /tmp/exam/course/8/deployment.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tornado-app
  namespace: tornado
spec:
  replicas: 1
  selector:
    matchLabels:
      app: tornado
  template:
    metadata:
      labels:
        app: tornado
    spec:
      containers:
      - name: web
        image: nginx:alpine
        envFrom:
        - configMapRef:
            name: tornado-config
EOF
echo "Setup complete for Question 8"
exit 0
