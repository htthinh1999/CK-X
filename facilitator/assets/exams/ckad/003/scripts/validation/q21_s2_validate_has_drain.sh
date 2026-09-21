#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if [ -f "/tmp/exam/course/21/drain-command.sh" ] && grep -q "kubectl drain" "/tmp/exam/course/21/drain-command.sh"; then
  echo "Success: contains kubectl drain"
  exit 0
else
  echo "Error: kubectl drain not found in file"
  exit 1
fi
