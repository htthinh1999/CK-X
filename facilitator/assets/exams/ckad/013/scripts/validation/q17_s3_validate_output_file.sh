#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f /tmp/exam/course/17/dns-output.txt ]; then
  echo "Success: dns-output.txt exists"
  exit 0
else
  echo "Error: /tmp/exam/course/17/dns-output.txt not found"
  exit 1
fi
