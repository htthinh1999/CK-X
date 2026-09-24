#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace ascend --dry-run=client -o yaml | kubectl apply -f - || true
# Apply the three broken pods (fix-it question)
kubectl delete pod bug-1 bug-2 bug-3 -n ascend --ignore-not-found >/dev/null 2>&1 || true
kubectl apply -f - <<'EOF' || true
apiVersion: v1
kind: Pod
metadata:
  name: bug-1
  namespace: ascend
spec:
  containers:
  - name: main
    image: busybox
    command: ["eccho", "hello"]
---
apiVersion: v1
kind: Pod
metadata:
  name: bug-2
  namespace: ascend
spec:
  containers:
  - name: main
    image: busybox
    command: ["sleep", "3600"]
    resources:
      requests:
        cpu: "1000"
---
apiVersion: v1
kind: Pod
metadata:
  name: bug-3
  namespace: ascend
spec:
  containers:
  - name: main
    image: nginx:1.999.9
EOF
echo "Setup complete for Question 5"
exit 0
