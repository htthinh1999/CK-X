#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace grain --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: v1
kind: Pod
metadata:
  name: app-pod
  namespace: grain
  labels:
    app: app
spec:
  containers:
  - name: nginx
    image: nginx:1.25
    ports:
    - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: app-svc
  namespace: grain
spec:
  type: ClusterIP
  selector:
    app: app
  ports:
  - port: 80
    targetPort: 80
EOF

echo "Setup complete for Question 3"
exit 0
