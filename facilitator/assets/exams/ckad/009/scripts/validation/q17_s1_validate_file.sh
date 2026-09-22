#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if [ -s /tmp/exam/course/17/username ]; then
  echo "Success: username file exists and is not empty"; exit 0
else
  echo "Error: /tmp/exam/course/17/username missing or empty"; exit 1
fi
