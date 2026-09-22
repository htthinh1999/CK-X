#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f "/tmp/exam/course/20/running-pods.txt" ]; then
  echo "Success: running-pods.txt exists"
  exit 0
else
  echo "Error: /tmp/exam/course/20/running-pods.txt not found"
  exit 1
fi
