#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f /tmp/exam/course/8/kustomization.yaml ]; then
  echo "Success: /tmp/exam/course/8/kustomization.yaml exists"
  exit 0
else
  echo "Error: /tmp/exam/course/8/kustomization.yaml not found"
  exit 1
fi
