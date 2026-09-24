#!/bin/bash

# Setup for Question 2: Pod with high CPU usage

# Create the troubleshooting namespace if it doesn't exist already
if ! kubectl get namespace troubleshooting &> /dev/null; then
    kubectl create namespace troubleshooting
fi

# Delete any existing pod with the same name
kubectl delete pod logging-pod -n troubleshooting --ignore-not-found=true

# Create a pod with a container that has high CPU usage and no resource limits
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: logging-pod
  namespace: troubleshooting
spec:
  containers:
  - name: cpu-consumer
    image: busybox
    command: ["/bin/sh", "-c"]
    args:
    - "while true; do echo 'Consuming CPU...'; done"
  - name: normal-container
    image: nginx
EOF

echo "Setup complete for Question 2: Created pod 'logging-pod' with high CPU usage container"
echo "Note: In a real environment, the 'cpu-consumer' container would actually consume high CPU."
echo "      The student needs to identify this container and set appropriate CPU limits."
exit 0 