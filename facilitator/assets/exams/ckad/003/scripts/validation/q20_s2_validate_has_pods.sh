#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f="/tmp/exam/course/20/running-pods.txt"
lc=$(wc -l <"$f" 2>/dev/null)
if [ -f "$f" ] && [ "$lc" -gt 0 ] 2>/dev/null; then
  echo "Success: file contains pod names"
  exit 0
else
  echo "Error: file empty or missing"
  exit 1
fi
