#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

# Q1 is file-based: student runs `helm create sea-app` under /tmp/exam/course/7/
mkdir -p /tmp/exam/course/7 || true

echo "Setup complete for Question 7"
exit 0
