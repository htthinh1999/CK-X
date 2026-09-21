#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

kubectl create namespace sentinel --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl delete pod data-processor -n sentinel --ignore-not-found=true >/dev/null 2>&1 || true
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: v1
kind: Pod
metadata:
  name: data-processor
  namespace: sentinel
spec:
  containers:
  - name: processor
    image: polinux/stress
    command: ["stress"]
    args: ["--vm", "1", "--vm-bytes", "150M", "--vm-hang", "1"]
    resources:
      requests:
        memory: "64Mi"
      limits:
        memory: "64Mi"
EOF

echo "Setup complete for Question 9"
exit 0
