#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace ocean --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - >/dev/null 2>&1 <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: api-service
  namespace: ocean
spec:
  ports:
  - port: 80
    targetPort: 80
  selector:
    app: api-app
EOF
echo "Setup complete for Question 20"
exit 0
