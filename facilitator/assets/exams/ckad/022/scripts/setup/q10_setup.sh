#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace triumph --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/10
kubectl apply -f - <<'EOF' || true
apiVersion: v1
kind: Pod
metadata:
  name: triumph-app
  namespace: triumph
spec:
  containers:
  - name: main
    image: busybox
    command: ["sh", "-c", "while true; do echo 'ERROR: connection lost'; sleep 10; done"]
EOF
echo "Setup complete for Question 10"
exit 0
