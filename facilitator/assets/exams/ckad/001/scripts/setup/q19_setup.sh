#!/bin/bash

# Setup for Question 19: Install Helm and deploy Bitnami Nginx

# Create the web namespace if it doesn't exist already
if ! kubectl get namespace web &> /dev/null; then
    kubectl create namespace web
fi

# Delete any existing helm installations of nginx
if command -v helm &> /dev/null; then
    helm uninstall nginx -n web --ignore-not-found
fi

echo "Setup complete for Question 19: Environment ready for installing Helm and deploying Bitnami Nginx"
echo "Note: The candidate should add the Bitnami repo if not already present: helm repo add bitnami https://charts.bitnami.com/bitnami"
exit 0 