#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace antenna --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Deployment with a NAMED container port (rx-http) and a NodePort Service whose
# targetPort refers to a port name that does not exist (http) -> no endpoints.
kubectl apply -f - <<'YAML' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dish-receiver
  namespace: antenna
  labels:
    app: dish-receiver
spec:
  replicas: 2
  selector:
    matchLabels:
      app: dish-receiver
  template:
    metadata:
      labels:
        app: dish-receiver
    spec:
      containers:
        - name: receiver
          image: nginx:1.25
          ports:
            - name: rx-http
              containerPort: 80
          resources:
            requests:
              cpu: 20m
              memory: 32Mi
            limits:
              cpu: 100m
              memory: 64Mi
---
apiVersion: v1
kind: Service
metadata:
  name: dish-receiver
  namespace: antenna
spec:
  type: NodePort
  selector:
    app: dish-receiver
  ports:
    - name: feed
      protocol: TCP
      port: 8080
      targetPort: http
      nodePort: 31313
YAML

echo "Setup complete for Question 7"
exit 0
