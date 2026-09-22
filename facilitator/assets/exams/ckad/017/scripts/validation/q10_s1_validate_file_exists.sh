#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -s /tmp/exam/course/10/events.txt ]; then
  echo "Success: events.txt exists and is non-empty"; exit 0
fi
echo "Error: /tmp/exam/course/10/events.txt not found or empty"; exit 1
