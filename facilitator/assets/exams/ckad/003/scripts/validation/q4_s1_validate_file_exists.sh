#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if [ -f "/tmp/exam/course/4/rendered.yaml" ]; then
  echo "Success: rendered.yaml exists"
  exit 0
else
  echo "Error: /tmp/exam/course/4/rendered.yaml not found"
  exit 1
fi
