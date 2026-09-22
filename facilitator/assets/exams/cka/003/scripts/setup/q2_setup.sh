#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX create namespace alpha --dry-run=client -o yaml | kubectl $CTX apply -f - || true
# Prerequisite workload the student's Service must select (independent of Q1).
kubectl $CTX -n alpha apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cache
  namespace: alpha
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cache
  template:
    metadata:
      labels:
        app: cache
    spec:
      containers:
        - name: redis
          image: redis:7
          ports:
            - containerPort: 6379
YAML
kubectl $CTX -n alpha delete service cache-svc --ignore-not-found=true
echo "Setup complete for Question 2"
exit 0
