#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if [ -s /tmp/exam/course/3/logs.txt ]; then
  echo "Success: logs.txt exists and is not empty"; exit 0
else
  echo "Error: /tmp/exam/course/3/logs.txt missing or empty"; exit 1
fi
