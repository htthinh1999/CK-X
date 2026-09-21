#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if [ -f "/tmp/exam/course/12/image/Dockerfile" ] && grep -q "ARG APP_VERSION" "/tmp/exam/course/12/image/Dockerfile"; then
  echo "Success: ARG APP_VERSION present"
  exit 0
else
  echo "Error: Dockerfile missing ARG APP_VERSION"
  exit 1
fi
