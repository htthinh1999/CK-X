#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
enf=$(kubectl get ns refuge -o jsonpath='{.metadata.labels.pod-security\.kubernetes\.io/enforce}' 2>/dev/null)
if [[ "$enf" == "restricted" ]]; then
  echo "Success: enforce=restricted label present"
  exit 0
fi
echo "Error: enforce label is '$enf', expected restricted"
exit 1
