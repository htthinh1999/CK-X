#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f "/tmp/exam/course/10/logs.txt" ]; then
  echo "Success: /tmp/exam/course/10/logs.txt exists"
  exit 0
fi
echo "Error: /tmp/exam/course/10/logs.txt not found"
exit 1
