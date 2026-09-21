#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if [ -d "/tmp/exam/course/1/sea-app/templates" ]; then
  echo "Success: templates directory exists"
  exit 0
else
  echo "Error: /tmp/exam/course/1/sea-app/templates directory not found"
  exit 1
fi
