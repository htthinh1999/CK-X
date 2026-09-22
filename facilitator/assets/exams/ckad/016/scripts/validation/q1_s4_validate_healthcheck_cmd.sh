#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f="/tmp/exam/course/1/Dockerfile"
if [ -f "$f" ] && grep -q "curl -f http://localhost/ || exit 1" "$f"; then
  echo "Success: HEALTHCHECK command correct"; exit 0
fi
echo "Error: HEALTHCHECK command 'curl -f http://localhost/ || exit 1' not found"; exit 1
