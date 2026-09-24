#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace hunt --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - >/dev/null 2>&1 <<'YAML' || true
apiVersion: v1
kind: ServiceAccount
metadata:
  name: hunt-sa
  namespace: hunt
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: hunt
data:
  app.properties: |
    server.port=8080
    server.host=0.0.0.0
    debug.enabled=false
YAML
echo "Setup complete for Question 16"
exit 0
