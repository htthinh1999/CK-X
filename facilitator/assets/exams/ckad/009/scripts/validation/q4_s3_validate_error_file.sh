#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

if [ -s /tmp/exam/course/4/error.txt ]; then
  echo "Success: error.txt exists and is not empty"; exit 0
else
  echo "Error: /tmp/exam/course/4/error.txt missing or empty"; exit 1
fi
