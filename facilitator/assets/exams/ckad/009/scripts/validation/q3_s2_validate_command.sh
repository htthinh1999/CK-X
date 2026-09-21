#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

cmd=$(kubectl get pod logger -n glade -o jsonpath='{.spec.containers[0].command}' 2>/dev/null)
if [[ "$cmd" == *"while"* ]] || [[ "$cmd" == *"echo"* ]]; then
  echo "Success: loop command configured"; exit 0
else
  echo "Error: command not configured correctly ('$cmd')"; exit 1
fi
