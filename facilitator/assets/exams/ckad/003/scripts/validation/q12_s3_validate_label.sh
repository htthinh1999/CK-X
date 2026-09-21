#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if [ -f "/tmp/exam/course/12/image/Dockerfile" ] && grep -q "LABEL.*version" "/tmp/exam/course/12/image/Dockerfile"; then
  echo "Success: LABEL version present"
  exit 0
else
  echo "Error: Dockerfile missing LABEL version"
  exit 1
fi
