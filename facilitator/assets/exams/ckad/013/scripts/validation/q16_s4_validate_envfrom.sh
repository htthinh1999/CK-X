#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
e=$(kubectl get pod config-pod -n eclipse -o jsonpath='{.spec.containers[0].envFrom}' 2>/dev/null)
if [[ "$e" == *"app-config"* ]]; then
  echo "Success: pod uses envFrom app-config"
  exit 0
else
  echo "Error: pod does not use envFrom with app-config"
  exit 1
fi
