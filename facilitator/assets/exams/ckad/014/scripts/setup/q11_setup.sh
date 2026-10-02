#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace eclipse --dry-run=client -o yaml | kubectl apply -f - || true

# Minimal haproxy config for the ambassador: listen on :8080, forward to the backend on 127.0.0.1:80
kubectl apply -f - <<'EOF' || true
apiVersion: v1
kind: ConfigMap
metadata:
  name: haproxy-config
  namespace: eclipse
data:
  haproxy.cfg: |
    defaults
      mode http
      timeout connect 5s
      timeout client 30s
      timeout server 30s

    frontend ambassador
      bind :8080
      default_backend legacy

    backend legacy
      server backend 127.0.0.1:80
EOF

echo "Setup complete for Question 11"
exit 0
