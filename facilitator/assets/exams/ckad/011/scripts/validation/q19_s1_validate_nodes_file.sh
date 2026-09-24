#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -s "/tmp/exam/course/19/nodes.txt" ]; then
  echo "Success: /tmp/exam/course/19/nodes.txt exists and is not empty"
  exit 0
else
  echo "Error: /tmp/exam/course/19/nodes.txt not found or empty"
  exit 1
fi
