#!/bin/bash

# Setup for Question 11: Create an Ingress resource

# Create the networking namespace if it doesn't exist already
if ! kubectl get namespace networking &> /dev/null; then
    kubectl create namespace networking
fi

# Delete any existing Ingress with the same name
kubectl delete ingress api-ingress -n networking --ignore-not-found=true

# Create a service to be used by the Ingress
kubectl delete service api-service -n networking --ignore-not-found=true
kubectl delete deployment api-backend -n networking --ignore-not-found=true

# Create a deployment for the API service
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-backend
  namespace: networking
spec:
  replicas: 2
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
      - name: api
        image: nginx
        ports:
        - containerPort: 80
EOF

# Create a service for the API deployment
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: api-service
  namespace: networking
spec:
  selector:
    app: api
  ports:
  - port: 80
    targetPort: 80
EOF

echo "Setup complete for Question 11: Created service 'api-service' for the Ingress resource"
exit 0 