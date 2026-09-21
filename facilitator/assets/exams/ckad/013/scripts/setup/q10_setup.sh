#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace solar --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/10
kubectl apply -f - >/dev/null 2>&1 <<'EOF' || true
apiVersion: v1
kind: Pod
metadata:
  name: stuck-pod
  namespace: solar
  labels:
    app: stuck
spec:
  nodeSelector:
    disktype: ssd
  containers:
    - name: web
      image: nginx:1.25
EOF
echo "Setup complete for Question 10"
exit 0
