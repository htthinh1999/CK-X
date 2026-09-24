#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace sunbeam --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/17
kubectl apply -f - >/dev/null 2>&1 <<'EOF' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dns-app
  namespace: sunbeam
spec:
  replicas: 1
  selector:
    matchLabels:
      app: dns-app
  template:
    metadata:
      labels:
        app: dns-app
    spec:
      containers:
        - name: web
          image: nginx:1.25
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: dns-svc
  namespace: sunbeam
spec:
  selector:
    app: wrong-dns
  ports:
    - port: 80
      targetPort: 80
      protocol: TCP
EOF
echo "Setup complete for Question 17"
exit 0
