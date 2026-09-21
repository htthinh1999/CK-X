#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

# Q1 is file-based: student runs `helm create sea-app` under /tmp/exam/course/1/
mkdir -p /tmp/exam/course/1 || true

echo "Setup complete for Question 1"
exit 0
