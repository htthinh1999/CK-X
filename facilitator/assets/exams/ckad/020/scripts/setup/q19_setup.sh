#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace zenith --dry-run=client -o yaml | kubectl apply -f - || true
kubectl create namespace ancient --dry-run=client -o yaml | kubectl apply -f - || true

# Pre-create the data-svc service in the ancient namespace
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: data-svc
  namespace: ancient
spec:
  selector:
    app: data
  ports:
  - port: 80
EOF

mkdir -p /tmp/exam/course/19

echo "Setup complete for Question 19"
exit 0
