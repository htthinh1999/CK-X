#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

kubectl create namespace corona --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
kubectl create namespace flame --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
kubectl label namespace flame name=flame --overwrite 2>/dev/null || true
kubectl apply -f - <<'EOF' || true
apiVersion: v1
kind: Pod
metadata:
  name: backend-pod
  namespace: corona
  labels:
    app: backend
    tier: api
    exam: ckad-simulation1
spec:
  containers:
  - name: backend
    image: nginx:1.21
    ports:
    - containerPort: 80
      name: http
    resources:
      requests:
        memory: "64Mi"
        cpu: "100m"
      limits:
        memory: "128Mi"
        cpu: "200m"
EOF

echo "Setup complete for Question 11"
exit 0
