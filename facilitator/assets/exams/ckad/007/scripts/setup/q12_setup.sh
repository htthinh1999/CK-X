#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace ocean --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: local-deploy
  namespace: ocean
  labels:
    app: local-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: local-app
  template:
    metadata:
      labels:
        app: local-app
    spec:
      containers:
      - name: nginx
        image: nginx:1.21
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
          limits:
            memory: "128Mi"
            cpu: "200m"
---
apiVersion: v1
kind: Service
metadata:
  name: local-svc
  namespace: ocean
spec:
  type: ClusterIP
  selector:
    app: local-app
  ports:
  - port: 80
    targetPort: 80
EOF
echo "Setup complete for Question 12"
exit 0
