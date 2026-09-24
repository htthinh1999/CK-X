#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace zephyr --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: blue
  namespace: zephyr
  labels:
    app: zephyr-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: zephyr-app
      version: blue
  template:
    metadata:
      labels:
        app: zephyr-app
        version: blue
    spec:
      containers:
      - name: app
        image: nginx:alpine
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: green
  namespace: zephyr
  labels:
    app: zephyr-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: zephyr-app
      version: green
  template:
    metadata:
      labels:
        app: zephyr-app
        version: green
    spec:
      containers:
      - name: app
        image: nginx:alpine
---
apiVersion: v1
kind: Service
metadata:
  name: zephyr-svc
  namespace: zephyr
spec:
  selector:
    app: zephyr-app
    version: blue
  ports:
  - port: 80
    targetPort: 80
EOF
echo "Setup complete for Question 19"
exit 0
