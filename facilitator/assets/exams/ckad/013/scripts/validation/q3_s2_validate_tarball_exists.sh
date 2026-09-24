#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f /tmp/exam/course/3/solar-app.tar ]; then
  echo "Success: tarball exists"
  exit 0
else
  echo "Error: tarball /tmp/exam/course/3/solar-app.tar not found"
  exit 1
fi
