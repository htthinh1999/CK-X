#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if [ -s "/tmp/exam/course/17/revision.txt" ]; then
  echo "Success: /tmp/exam/course/17/revision.txt exists and is not empty"
  exit 0
else
  echo "Error: /tmp/exam/course/17/revision.txt not found or empty"
  exit 1
fi
