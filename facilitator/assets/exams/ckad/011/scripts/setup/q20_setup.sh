#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

# Prerequisite: a running pod in storm so `kubectl top pods -n storm` has data.
kubectl create namespace storm --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

kubectl apply -f - >/dev/null 2>&1 <<'EOF' || true
apiVersion: v1
kind: Pod
metadata:
  name: metrics-pod
  namespace: storm
  labels:
    app: metrics-test
spec:
  containers:
  - name: nginx
    image: nginx:alpine
    resources:
      requests:
        cpu: "10m"
        memory: "32Mi"
      limits:
        cpu: "50m"
        memory: "64Mi"
EOF

mkdir -p /tmp/exam/course/20 || true

echo "Setup complete for Question 20"
exit 0
