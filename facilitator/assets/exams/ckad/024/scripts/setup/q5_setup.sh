#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace manifest --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Working Deployment (pods: app=manifest-api, tier=backend, nginx on port 80 "http")
# and a broken Service: wrong selector value AND wrong targetPort -> no endpoints.
kubectl -n manifest delete service manifest-api --ignore-not-found >/dev/null 2>&1 || true
kubectl -n manifest apply -f - >/dev/null 2>&1 <<'YAML' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: manifest-api
  namespace: manifest
  labels:
    app: manifest-api
spec:
  replicas: 2
  selector:
    matchLabels:
      app: manifest-api
  template:
    metadata:
      labels:
        app: manifest-api
        tier: backend
    spec:
      containers:
        - name: api
          image: nginx:1.25
          ports:
            - name: http
              containerPort: 80
          resources:
            requests:
              cpu: 10m
              memory: 16Mi
            limits:
              cpu: 50m
              memory: 64Mi
---
apiVersion: v1
kind: Service
metadata:
  name: manifest-api
  namespace: manifest
  labels:
    app: manifest-api
spec:
  type: ClusterIP
  selector:
    app: manifest-app
    tier: backend
  ports:
    - name: web
      protocol: TCP
      port: 8080
      targetPort: 8081
YAML

kubectl -n manifest rollout status deployment/manifest-api --timeout=120s >/dev/null 2>&1 || true

echo "Setup complete for Question 5"
exit 0
