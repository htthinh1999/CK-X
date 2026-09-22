#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -d "/tmp/exam/course/1/sea-app" ]; then
  echo "Success: chart directory /tmp/exam/course/1/sea-app exists"
  exit 0
else
  echo "Error: chart directory /tmp/exam/course/1/sea-app not found"
  exit 1
fi
