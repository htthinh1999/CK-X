#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
F=/tmp/exam/course/3/patch.json
if [ -f "$F" ] && grep -q "production" "$F" && grep -q "MODE" "$F"; then
  echo "Success: patch.json contains MODE=production"
  exit 0
else
  echo "Error: patch.json does not contain MODE and production"
  exit 1
fi
