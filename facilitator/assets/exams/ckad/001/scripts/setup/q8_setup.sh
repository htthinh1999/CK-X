#!/bin/bash

# Setup for Question 8: Create a LoadBalancer service

# Create the networking namespace if it doesn't exist already
if ! kubectl get namespace networking &> /dev/null; then
    kubectl create namespace networking
fi

# Delete any existing service with the same name
kubectl delete service public-web -n networking --ignore-not-found=true

# Create a deployment to be exposed by the LoadBalancer service
kubectl delete deployment web-frontend -n networking --ignore-not-found=true
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-frontend
  namespace: networking
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-frontend
  template:
    metadata:
      labels:
        app: web-frontend
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
EOF

echo "Setup complete for Question 8: Created deployment 'web-frontend' for the LoadBalancer service"
exit 0 