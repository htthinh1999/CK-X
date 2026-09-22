#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace cosmos --dry-run=client -o yaml | kubectl apply -f - || true

# Pre-create the broken stuck-pod (init container intentionally exits 1)
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: stuck-pod
  namespace: cosmos
spec:
  initContainers:
  - name: init-setup
    image: busybox:1.32
    command: ['sh', '-c', 'exit 1']
  containers:
  - name: main-app
    image: nginx:alpine
EOF

echo "Setup complete for Question 9"
exit 0
