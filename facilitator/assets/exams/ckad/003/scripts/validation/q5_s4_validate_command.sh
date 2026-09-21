#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
cmd=$(kubectl get pod crash-app -n ember -o jsonpath='{.spec.containers[0].command[0]}' 2>/dev/null)
if [ "$cmd" = "sleep" ]; then
  echo "Success: command is sleep"
  exit 0
else
  echo "Error: command[0] is '$cmd', expected sleep"
  exit 1
fi
