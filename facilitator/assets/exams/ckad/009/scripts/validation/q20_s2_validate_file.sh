#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if [ -s /tmp/exam/course/20/passwd ]; then
  echo "Success: passwd file exists and is not empty"; exit 0
else
  echo "Error: /tmp/exam/course/20/passwd missing or empty"; exit 1
fi
