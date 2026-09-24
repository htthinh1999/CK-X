#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f "/tmp/exam/course/15/values.yaml" ]; then
  echo "Success: values.yaml exists"
  exit 0
else
  echo "Error: /tmp/exam/course/15/values.yaml not found"
  exit 1
fi
