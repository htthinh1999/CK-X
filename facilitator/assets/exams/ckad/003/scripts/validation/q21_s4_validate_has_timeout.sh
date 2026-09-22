#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f "/tmp/exam/course/21/drain-command.sh" ] && grep -qE "timeout[= ]*[0-9]+" "/tmp/exam/course/21/drain-command.sh"; then
  echo "Success: timeout flag present"
  exit 0
else
  echo "Error: timeout flag not found"
  exit 1
fi
