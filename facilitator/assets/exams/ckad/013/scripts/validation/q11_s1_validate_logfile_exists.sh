#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f /tmp/exam/course/11/sidecar-logs.txt ]; then
  echo "Success: sidecar-logs.txt exists"
  exit 0
else
  echo "Error: /tmp/exam/course/11/sidecar-logs.txt not found"
  exit 1
fi
