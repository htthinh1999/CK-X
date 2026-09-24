#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace dawn --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - >/dev/null 2>&1 <<'EOF' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hardened-app
  namespace: dawn
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hardened
  template:
    metadata:
      labels:
        app: hardened
    spec:
      containers:
        - name: app
          image: nginx:1.25
          ports:
            - containerPort: 80
EOF
echo "Setup complete for Question 19"
exit 0
