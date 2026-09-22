#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f "/tmp/exam/course/7/password.txt" ]; then
  echo "Success: password.txt exists"
  exit 0
else
  echo "Error: /tmp/exam/course/7/password.txt not found"
  exit 1
fi
