#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f "/tmp/exam/course/12/image/Dockerfile" ]; then
  echo "Success: Dockerfile exists"
  exit 0
else
  echo "Error: /tmp/exam/course/12/image/Dockerfile not found"
  exit 1
fi
