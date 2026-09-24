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
    # Shell-less, distroless-style image whose entrypoint runs forever
    # (gcr.io/distroless/static has no binaries at all, so `sleep` could never start).
    image: registry.k8s.io/pause:3.9
EOF

echo "Setup complete for Question 11"
exit 0
