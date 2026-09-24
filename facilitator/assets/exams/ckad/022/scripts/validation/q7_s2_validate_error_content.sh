#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if grep -q "ERROR" /tmp/exam/course/7/logs.txt 2>/dev/null; then
  echo "Success: logs.txt contains ERROR"
  exit 0
fi
echo "Error: no ERROR found in /tmp/exam/course/7/logs.txt"
exit 1
