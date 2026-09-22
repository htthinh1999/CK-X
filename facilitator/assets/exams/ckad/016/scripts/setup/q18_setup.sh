#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace surge --dry-run=client -o yaml | kubectl apply -f - || true
kubectl delete ingress default-ing -n surge --ignore-not-found=true >/dev/null 2>&1 || true
kubectl apply -f - <<'YAML'
apiVersion: v1
kind: Service
metadata:
  name: fallback-svc
  namespace: surge
spec:
  selector:
    app: fallback
  ports:
  - port: 8080
    targetPort: 8080
YAML
echo "Setup complete for Question 18"
exit 0
