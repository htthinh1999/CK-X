#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if grep -q "root:" /tmp/exam/course/20/passwd 2>/dev/null; then
  echo "Success: passwd file contains root entry"; exit 0
else
  echo "Error: passwd file missing root entry"; exit 1
fi
