#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if [ -f "/tmp/exam/course/21/drain-command.sh" ]; then
  echo "Success: drain-command.sh exists"
  exit 0
else
  echo "Error: /tmp/exam/course/21/drain-command.sh not found"
  exit 1
fi
