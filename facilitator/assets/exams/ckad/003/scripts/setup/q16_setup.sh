#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace flame --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
kubectl apply -f - <<'EOF' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deploy
  namespace: flame
  labels:
    app: web-app
    exam: ckad-simulation1
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: web
        image: nginx:1.21
        ports:
        - containerPort: 80
          name: http-web
        - containerPort: 443
          name: https-web
        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
          limits:
            memory: "128Mi"
            cpu: "200m"
EOF

echo "Setup complete for Question 16"
exit 0
