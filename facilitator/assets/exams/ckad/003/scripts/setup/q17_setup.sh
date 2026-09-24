#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace phoenix --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
mkdir -p /tmp/exam/course/17
cat > /tmp/exam/course/17/lifecycle.yaml <<'EOF'
# Q14 - Pod Template for PostStart Hook
# Task: Add lifecycle postStart hook to create a file
---
apiVersion: v1
kind: Pod
metadata:
  name: lifecycle-pod
  namespace: phoenix
spec:
  containers:
  - name: main
    image: nginx:1.21
    ports:
    - containerPort: 80
    # TODO: Add lifecycle with postStart hook
EOF

echo "Setup complete for Question 17"
exit 0
