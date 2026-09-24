#!/bin/bash

# Create the troubleshooting namespace
kubectl create namespace troubleshooting

# Create a broken deployment - using an invalid image name
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: broken-deployment
  namespace: troubleshooting
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.19-invalid-tag
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"
EOF

# Wait a bit to ensure the deployment is created
sleep 2

echo "Broken deployment created in the troubleshooting namespace." 