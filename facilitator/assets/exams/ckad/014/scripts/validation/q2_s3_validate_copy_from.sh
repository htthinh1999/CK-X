#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
F=/tmp/exam/course/2/Dockerfile
if [ -f "$F" ] && grep -q "COPY --from=builder" "$F"; then
  echo "Success: binary copied from builder stage"
  exit 0
else
  echo "Error: COPY --from=builder not found"
  exit 1
fi
