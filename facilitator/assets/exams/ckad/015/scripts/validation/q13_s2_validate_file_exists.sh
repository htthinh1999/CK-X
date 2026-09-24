#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f /tmp/exam/course/13/pod.yaml ]; then
  echo "Success: /tmp/exam/course/13/pod.yaml exists"
  exit 0
else
  echo "Error: /tmp/exam/course/13/pod.yaml not found"
  exit 1
fi
