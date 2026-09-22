#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -s "/tmp/exam/course/13/previous.txt" ]; then
  echo "Success: /tmp/exam/course/13/previous.txt exists and contains output"
  exit 0
else
  echo "Error: /tmp/exam/course/13/previous.txt not found or empty"
  exit 1
fi
