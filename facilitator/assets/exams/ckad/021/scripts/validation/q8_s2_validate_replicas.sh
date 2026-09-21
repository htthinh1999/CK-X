#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
reps=$(kubectl get deployment my-app -n bulwark -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [[ "$reps" == "4" ]]; then
  echo "Success: replicas patched to 4"
  exit 0
fi
echo "Error: replicas is '$reps', expected 4"
exit 1
