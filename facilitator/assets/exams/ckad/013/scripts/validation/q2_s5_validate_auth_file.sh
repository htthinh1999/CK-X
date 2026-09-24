#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f /tmp/exam/course/2/auth-check.txt ]; then
  a=$(cat /tmp/exam/course/2/auth-check.txt 2>/dev/null | tr -d '[:space:]')
  if [ "$a" = "yes" ]; then echo "Success: auth-check.txt contains yes"; exit 0; else echo "Error: auth-check.txt has $a"; exit 1; fi
else
  echo "Error: /tmp/exam/course/2/auth-check.txt not found"
  exit 1
fi
