#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace poseidon --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: v1
kind: Service
metadata:
  name: api-svc
  namespace: poseidon
spec:
  type: ClusterIP
  ports:
  - port: 8080
    targetPort: 8080
  selector:
    app: api-backend
---
apiVersion: v1
kind: Service
metadata:
  name: web-svc
  namespace: poseidon
spec:
  type: ClusterIP
  ports:
  - port: 80
    targetPort: 80
  selector:
    app: web-frontend
EOF
echo "Setup complete for Question 15"
exit 0
