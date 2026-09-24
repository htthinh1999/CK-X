#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -s "/tmp/exam/course/6/pod.yaml" ]; then
  echo "Success: /tmp/exam/course/6/pod.yaml exists and is not empty"
  exit 0
else
  echo "Error: /tmp/exam/course/6/pod.yaml not found or empty"
  exit 1
fi
