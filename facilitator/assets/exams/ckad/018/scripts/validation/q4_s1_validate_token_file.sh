#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f /tmp/exam/course/4/token.txt ]; then
  val=$(cat /tmp/exam/course/4/token.txt 2>/dev/null)
  if [[ -n "$val" ]]; then
    echo "Success: token.txt exists and has content"; exit 0
  fi
  echo "Error: token.txt is empty"; exit 1
fi
echo "Error: /tmp/exam/course/4/token.txt not found"; exit 1
