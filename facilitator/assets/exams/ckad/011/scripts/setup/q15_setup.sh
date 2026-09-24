#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

# Prerequisite: a crashing pod that restarts so previous-container logs exist.
kubectl create namespace harbor --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

kubectl apply -f - >/dev/null 2>&1 <<'EOF' || true
apiVersion: v1
kind: Pod
metadata:
  name: restart-pod
  namespace: harbor
spec:
  containers:
  - name: app
    image: busybox:1.36
    command: ["/bin/sh", "-c"]
    args: ["echo 'Previous instance log entry'; sleep 3; exit 1"]
  restartPolicy: Always
EOF

mkdir -p /tmp/exam/course/15 || true

echo "Setup complete for Question 15"
exit 0
