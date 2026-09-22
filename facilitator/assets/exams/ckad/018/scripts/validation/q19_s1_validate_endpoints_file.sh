#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f /tmp/exam/course/19/endpoints.txt ]; then
  val=$(cat /tmp/exam/course/19/endpoints.txt 2>/dev/null)
  if [[ -n "$val" ]]; then
    echo "Success: endpoints.txt exists and has content"; exit 0
  fi
  echo "Error: endpoints.txt is empty"; exit 1
fi
echo "Error: /tmp/exam/course/19/endpoints.txt not found"; exit 1
