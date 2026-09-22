#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace tornado --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: v1
kind: Service
metadata:
  name: api-svc
  namespace: tornado
spec:
  selector:
    app: api
  ports:
  - port: 8080
    targetPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: web-svc
  namespace: tornado
spec:
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 80
EOF
echo "Setup complete for Question 18"
exit 0
