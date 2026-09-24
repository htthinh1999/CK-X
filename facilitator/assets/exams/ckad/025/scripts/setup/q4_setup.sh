#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=mirror

kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Recreate from scratch so the strategy starts as Recreate on every run
kubectl -n "$NS" delete deployment reflector --ignore-not-found >/dev/null 2>&1 || true

kubectl -n "$NS" apply -f - >/dev/null 2>&1 <<'YAML' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: reflector
  namespace: mirror
  labels:
    app: reflector
  annotations:
    kubernetes.io/change-cause: "initial release on nginx 1.25"
spec:
  replicas: 3
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: reflector
  template:
    metadata:
      labels:
        app: reflector
    spec:
      containers:
        - name: web
          image: nginx:1.25
          ports:
            - containerPort: 80
          readinessProbe:
            httpGet:
              path: /
              port: 80
            periodSeconds: 5
          resources:
            requests:
              cpu: 10m
              memory: 32Mi
            limits:
              cpu: 100m
              memory: 128Mi
YAML

echo "Setup complete for Question 4"
exit 0
