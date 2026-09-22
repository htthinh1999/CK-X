#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f /tmp/exam/course/10/metrics.txt ]; then
  val=$(cat /tmp/exam/course/10/metrics.txt 2>/dev/null)
  if [[ -n "$val" ]]; then
    echo "Success: metrics.txt exists and has content"; exit 0
  fi
  echo "Error: metrics.txt is empty"; exit 1
fi
echo "Error: /tmp/exam/course/10/metrics.txt not found"; exit 1
