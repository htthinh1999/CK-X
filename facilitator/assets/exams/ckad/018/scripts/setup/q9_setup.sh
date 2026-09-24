#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace melody --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
kubectl delete pod ambassador-pod -n melody --ignore-not-found=true 2>/dev/null || true
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: haproxy-config
  namespace: melody
data:
  haproxy.cfg: |
    global
      daemon
      maxconn 256
    defaults
      mode http
      timeout connect 5000ms
      timeout client 50000ms
      timeout server 50000ms
EOF
echo "Setup complete for Question 9"
exit 0
