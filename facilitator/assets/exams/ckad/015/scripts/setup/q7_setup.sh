#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace sirocco --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/7
for p in sirocco-pod-a sirocco-pod-b sirocco-pod-c; do
kubectl apply -f - <<EOF >/dev/null 2>&1 || true
apiVersion: v1
kind: Pod
metadata:
  name: $p
  namespace: sirocco
spec:
  containers:
  - name: app
    image: busybox:1.31.1
    command: ["sleep", "3600"]
    resources:
      requests:
        memory: "16Mi"
EOF
done
echo "Setup complete for Question 7"
exit 0
