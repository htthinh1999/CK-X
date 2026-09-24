#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace spring --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: v1
kind: Pod
metadata:
  name: frontend
  namespace: spring
  labels:
    role: wrong-frontend
spec:
  containers:
    - name: nginx
      image: nginx:alpine
---
apiVersion: v1
kind: Pod
metadata:
  name: backend
  namespace: spring
  labels:
    role: wrong-backend
spec:
  containers:
    - name: nginx
      image: nginx:alpine
---
apiVersion: v1
kind: Pod
metadata:
  name: database
  namespace: spring
  labels:
    role: wrong-db
spec:
  containers:
    - name: nginx
      image: nginx:alpine
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
  namespace: spring
spec:
  podSelector: {}
  policyTypes:
    - Ingress
    - Egress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
  namespace: spring
spec:
  podSelector:
    matchLabels:
      role: backend
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              role: frontend
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-backend-to-db
  namespace: spring
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              role: backend
EOF
echo "Setup complete for Question 3"
exit 0
