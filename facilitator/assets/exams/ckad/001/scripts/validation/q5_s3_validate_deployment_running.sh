#!/bin/bash

# Validate if the deployment 'nginx-deployment' in namespace 'dev' is using the correct image (nginx:latest)
IMAGE=$(kubectl get deployment nginx-deployment -n dev -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)

if [ "$IMAGE" = "nginx:latest" ]; then
    echo "Success: Deployment 'nginx-deployment' is using the correct image 'nginx:latest'"
    exit 0
else
    echo "Error: Deployment 'nginx-deployment' is not using the correct image. Found: '$IMAGE', Expected: 'nginx:latest'"
    exit 1
fi 