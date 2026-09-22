#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f "/tmp/exam/course/20/dns-output.txt" ]; then
  echo "Success: /tmp/exam/course/20/dns-output.txt exists"
  exit 0
fi
echo "Error: /tmp/exam/course/20/dns-output.txt not found"
exit 1
