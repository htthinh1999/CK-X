#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if [ -f "/tmp/exam/course/2/fire-app.yaml" ]; then
  echo "Success: fire-app.yaml saved"
  exit 0
else
  echo "Error: /tmp/exam/course/2/fire-app.yaml not found"
  exit 1
fi
