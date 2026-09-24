#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace apex --dry-run=client -o yaml | kubectl apply -f - || true
kubectl apply -f - <<'EOF' || true
apiVersion: v1
kind: Pod
metadata:
  name: distroless-pod
  namespace: apex
spec:
  containers:
  - name: main
    image: gcr.io/distroless/static
    command: ["/ko-app/example"]
EOF
echo "Setup complete for Question 10"
exit 0
