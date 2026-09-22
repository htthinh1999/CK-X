#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace lighthouse --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

cat <<'YAML' | kubectl apply -f - >/dev/null 2>&1 || true
apiVersion: v1
kind: ConfigMap
metadata:
  name: lamp-config
  namespace: lighthouse
data:
  rotation: slow
  color: white
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: lamp-driver
  namespace: lighthouse
  labels:
    app: lamp-driver
spec:
  replicas: 2
  selector:
    matchLabels:
      app: lamp-driver
  template:
    metadata:
      labels:
        app: lamp-driver
    spec:
      containers:
        - name: driver
          image: nginx:1.25
          ports:
            - containerPort: 80
          env:
            - name: LAMP_ROTATION
              valueFrom:
                configMapKeyRef:
                  name: lamp-config
                  key: rotation
          resources:
            requests:
              cpu: 10m
              memory: 16Mi
            limits:
              cpu: 50m
              memory: 64Mi
YAML

# Make sure the pods are already running with the old value before the student starts
kubectl -n lighthouse wait --for=condition=Available deployment/lamp-driver --timeout=120s >/dev/null 2>&1 || true

echo "Setup complete for Question 14"
exit 0
