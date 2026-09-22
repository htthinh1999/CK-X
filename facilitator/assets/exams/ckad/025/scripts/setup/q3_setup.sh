#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=relay

kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# No policies at start
kubectl -n "$NS" delete networkpolicy --all >/dev/null 2>&1 || true

kubectl -n "$NS" apply -f - >/dev/null 2>&1 <<'YAML' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: collector
  namespace: relay
  labels:
    app: collector
spec:
  replicas: 2
  selector:
    matchLabels:
      app: collector
  template:
    metadata:
      labels:
        app: collector
    spec:
      containers:
        - name: collector
          image: busybox:1.36
          command: ["sh", "-c", "sleep 86400"]
          resources:
            requests:
              cpu: 10m
              memory: 16Mi
            limits:
              cpu: 50m
              memory: 32Mi
---
apiVersion: v1
kind: Pod
metadata:
  name: archive
  namespace: relay
  labels:
    app: archive
spec:
  containers:
    - name: redis
      image: redis:7-alpine
      ports:
        - containerPort: 6379
      resources:
        requests:
          cpu: 20m
          memory: 32Mi
        limits:
          cpu: 100m
          memory: 128Mi
---
apiVersion: v1
kind: Service
metadata:
  name: archive
  namespace: relay
spec:
  selector:
    app: archive
  ports:
    - name: redis
      port: 6379
      targetPort: 6379
      protocol: TCP
---
apiVersion: v1
kind: Pod
metadata:
  name: webcache
  namespace: relay
  labels:
    app: webcache
spec:
  containers:
    - name: nginx
      image: nginx:1.25
      ports:
        - containerPort: 80
      resources:
        requests:
          cpu: 10m
          memory: 32Mi
        limits:
          cpu: 100m
          memory: 128Mi
---
apiVersion: v1
kind: Service
metadata:
  name: webcache
  namespace: relay
spec:
  selector:
    app: webcache
  ports:
    - name: http
      port: 80
      targetPort: 80
      protocol: TCP
---
apiVersion: v1
kind: Pod
metadata:
  name: dashboard
  namespace: relay
  labels:
    app: dashboard
spec:
  containers:
    - name: ui
      image: busybox:1.36
      command: ["sh", "-c", "sleep 86400"]
      resources:
        requests:
          cpu: 10m
          memory: 16Mi
        limits:
          cpu: 50m
          memory: 32Mi
YAML

echo "Setup complete for Question 3"
exit 0
