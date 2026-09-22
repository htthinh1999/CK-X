#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace corona --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/11
kubectl apply -f - >/dev/null 2>&1 <<'EOF' || true
apiVersion: v1
kind: Pod
metadata:
  name: multi-logger
  namespace: corona
  labels:
    app: logger
spec:
  containers:
    - name: app
      image: busybox:1.36
      command: ["/bin/sh", "-c"]
      args: ["i=0; while true; do i=$((i+1)); echo \"$i: app processing request\"; sleep 3; done"]
    - name: sidecar
      image: busybox:1.36
      command: ["/bin/sh", "-c"]
      args: ["i=0; while true; do i=$((i+1)); echo \"$i: sidecar syncing data\"; sleep 5; done"]
EOF
echo "Setup complete for Question 11"
exit 0
