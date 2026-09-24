#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
rp=$(kubectl get pod batch-worker -n abyss -o jsonpath='{.spec.restartPolicy}' 2>/dev/null)
if [ "$rp" = "OnFailure" ]; then
  echo "Success: restartPolicy is OnFailure"; exit 0
fi
echo "Error: restartPolicy is '$rp', expected OnFailure"; exit 1
