#!/bin/bash

# Setup for Question 18: Create a Job to backup configuration files

# Create the networking namespace if it doesn't exist already
if ! kubectl get namespace networking &> /dev/null; then
    kubectl create namespace networking
fi

# Delete any existing job with the same name
kubectl delete job backup-job -n networking --ignore-not-found=true

# Create a ConfigMap with sample configuration files
kubectl delete configmap example-config -n networking --ignore-not-found=true
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: example-config
  namespace: networking
data:
  nginx.conf: |
    server {
      listen 80;
      server_name example.com;
      location / {
        root /usr/share/nginx/html;
        index index.html index.htm;
      }
    }
  app.conf: |
    log_level=debug
    port=8080
    max_connections=100
EOF

echo "Setup complete for Question 18: Environment ready for creating backup Job"
echo "Note: The example ConfigMap is just for reference. In a real environment,"
echo "      the student would need to create a Pod that mounts both /etc/config and /backup directories."
exit 0 