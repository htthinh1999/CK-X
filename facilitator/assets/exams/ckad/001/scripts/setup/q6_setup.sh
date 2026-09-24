#!/bin/bash

# Setup for Question 6: Create a ClusterIP service

# Create the networking namespace if it doesn't exist already
if ! kubectl get namespace networking &> /dev/null; then
    kubectl create namespace networking
fi

# Delete any existing service with the same name
kubectl delete service internal-app -n networking --ignore-not-found=true

# Create backend pods with the required labels
kubectl delete deployment backend-app -n networking --ignore-not-found=true
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-app
  namespace: networking
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: nginx
        ports:
        - containerPort: 8080
        command: ["/bin/sh", "-c"]
        args: ["nginx -g 'daemon off;' & echo 'Backend service running on port 8080' && sleep infinity"]
EOF

echo "Setup complete for Question 6: Created backend pods with label app=backend for the ClusterIP service"
exit 0 