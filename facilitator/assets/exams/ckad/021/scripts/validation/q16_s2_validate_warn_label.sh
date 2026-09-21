#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
wrn=$(kubectl get ns refuge -o jsonpath='{.metadata.labels.pod-security\.kubernetes\.io/warn}' 2>/dev/null)
if [[ "$wrn" == "baseline" ]]; then
  echo "Success: warn=baseline label present"
  exit 0
fi
echo "Error: warn label is '$wrn', expected baseline"
exit 1
