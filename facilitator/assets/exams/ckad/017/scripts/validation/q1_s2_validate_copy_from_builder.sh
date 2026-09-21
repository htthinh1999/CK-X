#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
F=/tmp/exam/course/1/Dockerfile
if [ -f "$F" ] && grep -q "COPY --from=builder" "$F"; then
  echo "Success: COPY --from=builder found"; exit 0
fi
echo "Error: COPY --from=builder not found in $F"; exit 1
