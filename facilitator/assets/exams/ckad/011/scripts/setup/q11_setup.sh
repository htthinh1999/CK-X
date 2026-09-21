#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

# Prerequisite: a broken pod the student will describe.
kubectl create namespace pearl --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

kubectl apply -f - >/dev/null 2>&1 <<'EOF' || true
apiVersion: v1
kind: Pod
metadata:
  name: problem-pod
  namespace: pearl
spec:
  containers:
  - name: app
    image: nginx:invalid-tag-that-does-not-exist
    ports:
    - containerPort: 80
EOF

mkdir -p /tmp/exam/course/11 || true

echo "Setup complete for Question 11"
exit 0
