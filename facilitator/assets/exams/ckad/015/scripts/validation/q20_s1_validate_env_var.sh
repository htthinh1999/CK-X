#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
f=/tmp/exam/course/20/svc-env.txt
[ -f "$f" ] || { echo "Error: $f not found"; exit 1; }
if grep -q "SIROCCO_BACKEND_SERVICE_HOST" "$f"; then
  echo "Success: svc-env.txt contains SIROCCO_BACKEND_SERVICE_HOST"
  exit 0
else
  echo "Error: SIROCCO_BACKEND_SERVICE_HOST not found in svc-env.txt"
  exit 1
fi
