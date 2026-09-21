#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

kubectl create namespace sentinel --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/18
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: v1
kind: Service
metadata:
  name: main-svc
  namespace: sentinel
spec:
  ports:
  - port: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: main-ingress
  namespace: sentinel
spec:
  ingressClassName: nginx
  rules:
  - host: sentinel.dojo.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: main-svc
            port:
              number: 80
EOF

echo "Setup complete for Question 18"
exit 0
