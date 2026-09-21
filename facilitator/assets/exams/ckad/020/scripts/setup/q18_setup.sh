#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

kubectl create namespace cosmos --dry-run=client -o yaml | kubectl apply -f - || true

# Pre-create cosmos-svc and cosmos-ingress (ingress missing ingressClassName and wrong port 8080)
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: cosmos-svc
  namespace: cosmos
spec:
  selector:
    app: cosmos
  ports:
  - port: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: cosmos-ingress
  namespace: cosmos
spec:
  rules:
  - host: cosmos.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: cosmos-svc
            port:
              number: 8080
EOF

echo "Setup complete for Question 18"
exit 0
