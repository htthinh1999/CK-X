#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace lagoon --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-v1
  namespace: lagoon
  labels:
    app: api
    version: v1
spec:
  replicas: 2
  selector:
    matchLabels:
      app: api
      version: v1
  template:
    metadata:
      labels:
        app: api
        version: v1
    spec:
      containers:
      - name: api
        image: nginx:1.21
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: api-v1-svc
  namespace: lagoon
spec:
  selector:
    app: api
    version: v1
  ports:
  - port: 80
    targetPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-v2
  namespace: lagoon
  labels:
    app: api
    version: v2
spec:
  replicas: 2
  selector:
    matchLabels:
      app: api
      version: v2
  template:
    metadata:
      labels:
        app: api
        version: v2
    spec:
      containers:
      - name: api
        image: nginx:1.22
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: api-v2-svc
  namespace: lagoon
spec:
  selector:
    app: api
    version: v2
  ports:
  - port: 80
    targetPort: 80
EOF
echo "Setup complete for Question 8"
exit 0
