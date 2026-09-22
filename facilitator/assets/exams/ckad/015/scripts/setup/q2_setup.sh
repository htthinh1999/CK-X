#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace gale --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: v1
kind: Pod
metadata:
  name: wind-logger
  namespace: gale
spec:
  containers:
  - name: app
    image: busybox:1.31.1
    command: ["sh", "-c", "while true; do echo 'Wind speed 100mph' >> /var/log/wind.log; sleep 5; done"]
    volumeMounts:
    - name: logs
      mountPath: /var/log
  volumes:
  - name: logs
    emptyDir: {}
EOF
echo "Setup complete for Question 2"
exit 0
