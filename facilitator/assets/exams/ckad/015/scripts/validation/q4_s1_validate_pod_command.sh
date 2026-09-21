#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl get pod tempest-debug -n tempest >/dev/null 2>&1 || { echo "Error: Pod tempest-debug not found in tempest"; exit 1; }
cmd=$(kubectl get pod tempest-debug -n tempest -o jsonpath='{.spec.containers[0].command[0]}' 2>/dev/null)
if [ "$cmd" == "sleep" ]; then
  echo "Success: container command starts with sleep"
  exit 0
else
  echo "Error: container command[0]='$cmd' (expected sleep)"
  exit 1
fi
