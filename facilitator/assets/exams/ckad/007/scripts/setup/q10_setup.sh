#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace anchor --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/10
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: v1
kind: Pod
metadata:
  name: troubled-app
  namespace: anchor
  labels:
    app: troubled-app
spec:
  containers:
  - name: app
    image: nginx:1.21
    volumeMounts:
    - name: data
      mountPath: /data
    resources:
      requests:
        memory: "64Mi"
        cpu: "100m"
      limits:
        memory: "128Mi"
        cpu: "200m"
  volumes:
  - name: data
    emptyDir: {}
EOF
echo "Setup complete for Question 10"
exit 0
