#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace bulwark --dry-run=client -o yaml | kubectl apply -f - || true
kubectl apply -f - <<'YAML'
apiVersion: v1
kind: Service
metadata:
  name: v1-service
  namespace: bulwark
spec:
  ports:
  - port: 80
  selector:
    app: v1
---
apiVersion: v1
kind: Service
metadata:
  name: v2-service
  namespace: bulwark
spec:
  ports:
  - port: 80
  selector:
    app: v2
YAML
echo "Setup complete for Question 18"
exit 0
