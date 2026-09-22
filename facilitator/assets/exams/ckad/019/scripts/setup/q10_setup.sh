#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace outpost --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: v1
kind: Pod
metadata:
  name: secure-app
  namespace: outpost
spec:
  containers:
  - name: app
    image: gcr.io/distroless/static-debian11
    command: ["sleep", "3600"]
EOF

echo "Setup complete for Question 10"
exit 0
