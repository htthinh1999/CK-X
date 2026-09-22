#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace tempo --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: external-db-svc
  namespace: tempo
spec:
  ports:
  - port: 3306
---
apiVersion: discovery.k8s.io/v1
kind: EndpointSlice
metadata:
  name: external-db-slice
  namespace: tempo
  labels:
    kubernetes.io/service-name: external-db-svc
addressType: IPv4
ports:
- name: mysql
  port: 3306
endpoints:
- addresses:
  - "192.168.1.100"
  - "192.168.1.101"
EOF
mkdir -p /tmp/exam/course/19
echo "Setup complete for Question 19"
exit 0
