#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f="/tmp/exam/course/2/Dockerfile"
if [ -f "$f" ] && grep -q "HEALTHCHECK" "$f" && grep -q "\-\-interval=10s" "$f" && grep -q "\-\-timeout=3s" "$f"; then
  echo "Success: HEALTHCHECK timing options correct"; exit 0
fi
echo "Error: HEALTHCHECK with --interval=10s and --timeout=3s not found"; exit 1
