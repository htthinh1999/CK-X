#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f="/tmp/exam/course/13/token.txt"
if [ -f "$f" ]; then
  ts=$(wc -c <"$f")
  if [ "$ts" -gt 100 ]; then
    echo "Success: token file looks valid ($ts bytes)"
    exit 0
  fi
  echo "Error: token file empty or invalid ($ts bytes)"
  exit 1
fi
echo "Error: $f missing"
exit 1
