#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace void --dry-run=client -o yaml | kubectl apply -f - || true

kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: dns-tester
  namespace: void
spec:
  containers:
  - name: tester
    image: busybox:1.36
    command: ["sleep", "3600"]
EOF

mkdir -p /tmp/exam/course/18

echo "Setup complete for Question 18"
exit 0
