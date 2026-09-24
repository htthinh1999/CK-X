#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
min_reps=$(kubectl get hpa api-hpa -n refuge -o jsonpath='{.spec.minReplicas}' 2>/dev/null)
if [[ "$min_reps" == "2" ]]; then
  echo "Success: HPA minReplicas is 2"
  exit 0
fi
echo "Error: HPA minReplicas is '$min_reps', expected 2"
exit 1
