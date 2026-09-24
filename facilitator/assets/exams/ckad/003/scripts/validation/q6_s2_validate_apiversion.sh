#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f "/tmp/exam/course/6/rendered.yaml" ] && grep -q "apiVersion:" "/tmp/exam/course/6/rendered.yaml"; then
  echo "Success: contains apiVersion"
  exit 0
else
  echo "Error: rendered.yaml missing apiVersion"
  exit 1
fi
