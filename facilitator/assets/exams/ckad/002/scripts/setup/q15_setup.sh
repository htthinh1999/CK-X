#!/bin/bash

# Create namespace and sample resources for custom columns demo
kubectl create namespace custom-columns-demo > /dev/null 2>&1

# Create sample pods and deployments with different images
kubectl apply -f - <<EOF > /dev/null 2>&1
apiVersion: v1
kind: Namespace
metadata:
  name: custom-columns-demo
---
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  namespace: custom-columns-demo
spec:
  containers:
  - name: nginx
    image: nginx:1.19
---
apiVersion: v1
kind: Pod
metadata:
  name: busybox-pod
  namespace: custom-columns-demo
spec:
  containers:
  - name: busybox
    image: busybox:latest
    command: ["sleep", "3600"]
---
apiVersion: v1
kind: Pod
metadata:
  name: multi-container-pod
  namespace: custom-columns-demo
spec:
  containers:
  - name: nginx
    image: nginx:alpine
  - name: sidecar
    image: busybox:1.34
    command: ["sleep", "3600"]
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-deployment
  namespace: custom-columns-demo
spec:
  replicas: 2
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - name: redis
        image: redis:alpine
EOF

echo "Setup complete for Question 15"
exit 0 