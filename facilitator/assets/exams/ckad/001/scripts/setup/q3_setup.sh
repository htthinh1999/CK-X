#!/bin/bash

# Setup for Question 3: Create a NetworkPolicy

# Create the networking namespace if it doesn't exist already
if ! kubectl get namespace networking &> /dev/null; then
    kubectl create namespace networking
fi

# Delete any existing NetworkPolicy with the same name
kubectl delete networkpolicy allow-traffic -n networking --ignore-not-found=true

# Create pods with the required labels for testing the network policy
kubectl delete pod -l app=web -n networking --ignore-not-found=true
kubectl delete pod -l tier=frontend -n networking --ignore-not-found=true

# Create a web pod with label app=web
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: web-pod
  namespace: networking
  labels:
    app: web
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80
EOF

# Create a frontend pod with label tier=frontend
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: frontend-pod
  namespace: networking
  labels:
    tier: frontend
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["sleep", "3600"]
EOF

# Create a pod with no relevant labels for testing isolation
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: other-pod
  namespace: networking
  labels:
    tier: other
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["sleep", "3600"]
EOF

echo "Setup complete for Question 3: Created pods with necessary labels for NetworkPolicy testing"
exit 0 