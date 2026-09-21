#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if [ -f "/tmp/exam/course/4/rendered.yaml" ] && grep -q "kind:" "/tmp/exam/course/4/rendered.yaml"; then
  echo "Success: contains kind"
  exit 0
else
  echo "Error: rendered.yaml missing kind"
  exit 1
fi
