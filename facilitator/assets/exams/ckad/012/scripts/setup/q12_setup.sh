#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace bastion --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - >/dev/null 2>&1 <<'EOF' || true
apiVersion: v1
kind: ServiceAccount
metadata:
  name: pod-reader-sa
  namespace: bastion
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pod-reader
  namespace: bastion
spec:
  replicas: 1
  selector:
    matchLabels:
      app: pod-reader
  template:
    metadata:
      labels:
        app: pod-reader
    spec:
      serviceAccountName: pod-reader-sa
      containers:
      - name: pod-reader
        image: busybox:1.36
        command: ["sh", "-c", "while true; do wget -qO- --header='Authorization: Bearer '$(cat /var/run/secrets/kubernetes.io/serviceaccount/token) https://kubernetes.default.svc/api/v1/namespaces/bastion/pods --no-check-certificate 2>&1 | head -5; sleep 30; done"]
EOF
echo "Setup complete for Question 12"
exit 0
