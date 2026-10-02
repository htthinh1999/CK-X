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
      maxconn 256
    defaults
      mode http
      timeout connect 5000ms
      timeout client 50000ms
      timeout server 50000ms
    frontend ambassador
      bind 127.0.0.1:8080
      default_backend external-service
    backend external-service
      server external example.com:80 init-addr last,libc,none
EOF
echo "Setup complete for Question 9"
exit 0
