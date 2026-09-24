#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -s "/tmp/exam/course/1/config.env" ]; then
  echo "Success: /tmp/exam/course/1/config.env exists and is not empty"
  exit 0
else
  echo "Error: /tmp/exam/course/1/config.env not found or empty"
  exit 1
fi
