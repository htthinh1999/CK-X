#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -s /tmp/exam/course/10/events.txt ] && grep -q "Warning" /tmp/exam/course/10/events.txt; then
  echo "Success: Warning events found in file"; exit 0
fi
echo "Error: no Warning text found in events.txt"; exit 1
