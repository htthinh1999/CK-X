#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace sirocco --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/20
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: v1
kind: Service
metadata:
  name: sirocco-backend
  namespace: sirocco
spec:
  selector:
    app: backend
  ports:
  - port: 80
EOF
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: v1
kind: Pod
metadata:
  name: sirocco-app
  namespace: sirocco
spec:
  containers:
  - name: app
    image: busybox:1.31.1
    command: ["sleep", "3600"]
EOF
echo "Setup complete for Question 20"
exit 0
