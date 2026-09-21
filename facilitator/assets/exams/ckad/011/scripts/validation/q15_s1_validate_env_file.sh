#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if [ -s "/tmp/exam/course/15/config.env" ]; then
  echo "Success: /tmp/exam/course/15/config.env exists and is not empty"
  exit 0
else
  echo "Error: /tmp/exam/course/15/config.env not found or empty"
  exit 1
fi
