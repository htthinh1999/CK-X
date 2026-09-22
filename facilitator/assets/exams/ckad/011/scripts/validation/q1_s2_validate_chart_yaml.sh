#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f "/tmp/exam/course/1/sea-app/Chart.yaml" ]; then
  echo "Success: Chart.yaml exists"
  exit 0
else
  echo "Error: /tmp/exam/course/1/sea-app/Chart.yaml not found"
  exit 1
fi
