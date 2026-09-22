#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace rampart --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/14
cat > /tmp/exam/course/14/broken-deploy.yaml <<'EOF'
# This manifest contains deprecated API version and fields
# Fix it so it can be applied to the cluster
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: legacy-app
  namespace: rampart
spec:
  replicas: 2
  rollbackTo:
    revision: 0
  template:
    metadata:
      labels:
        app: legacy-app
    spec:
      containers:
      - name: legacy-app
        image: nginx:1.25
        ports:
        - containerPort: 80
EOF
echo "Setup complete for Question 14"
exit 0
