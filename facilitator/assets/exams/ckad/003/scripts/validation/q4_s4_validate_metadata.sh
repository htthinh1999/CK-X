#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if [ -f "/tmp/exam/course/4/rendered.yaml" ] && grep -q "metadata:" "/tmp/exam/course/4/rendered.yaml"; then
  echo "Success: contains metadata"
  exit 0
else
  echo "Error: rendered.yaml missing metadata"
  exit 1
fi
