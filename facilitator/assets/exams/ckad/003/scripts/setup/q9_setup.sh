#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace ember --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
kubectl delete pod crash-app -n ember --ignore-not-found=true >/dev/null 2>&1 || true
kubectl apply -f - <<'EOF' || true
apiVersion: v1
kind: Pod
metadata:
  name: crash-app
  namespace: ember
  labels:
    app: crash-app
    exam: ckad-simulation1
spec:
  containers:
  - name: app
    image: busybox:1.36
    command: ["sleepx", "3600"]
    resources:
      requests:
        memory: "32Mi"
        cpu: "50m"
      limits:
        memory: "64Mi"
        cpu: "100m"
EOF

echo "Setup complete for Question 9"
exit 0
