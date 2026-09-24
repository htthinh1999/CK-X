#!/bin/bash

# Setup for Question 21: Service with incorrect selector not routing traffic to pods

# Create the troubleshooting namespace if it doesn't exist already
if ! kubectl get namespace troubleshooting &> /dev/null; then
    kubectl create namespace troubleshooting
fi

# Delete any existing resources with the same names
kubectl delete service web-service -n troubleshooting --ignore-not-found=true
kubectl delete deployment web-app -n troubleshooting --ignore-not-found=true

# Create a deployment with label app=web-app
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  namespace: troubleshooting
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
EOF

# Create a service with incorrect selector (app=web instead of app=web-app)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: web-service
  namespace: troubleshooting
spec:
  selector:
    app: web  # Incorrect selector, should be app=web-app
  ports:
  - port: 80
    targetPort: 3030
EOF

echo "Setup complete for Question 21: Created service 'web-service' with incorrect selector"
exit 0 