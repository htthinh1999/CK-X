#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

if grep -qi "no such file\|not exist\|cannot access" /tmp/exam/course/4/error.txt 2>/dev/null; then
  echo "Success: error message captured"; exit 0
else
  echo "Error: error message not found in file"; exit 1
fi
