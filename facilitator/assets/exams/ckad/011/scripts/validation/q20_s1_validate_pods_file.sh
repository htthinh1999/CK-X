#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -s "/tmp/exam/course/20/top-pods.txt" ]; then
  echo "Success: /tmp/exam/course/20/top-pods.txt exists and is not empty"
  exit 0
else
  echo "Error: /tmp/exam/course/20/top-pods.txt not found or empty"
  exit 1
fi
