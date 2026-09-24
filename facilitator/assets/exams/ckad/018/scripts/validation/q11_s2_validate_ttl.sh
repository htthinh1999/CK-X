#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
ttl=$(kubectl get job data-cleanup -n rhythm -o jsonpath='{.spec.ttlSecondsAfterFinished}' 2>/dev/null)
if [ "$ttl" == "10" ]; then
  echo "Success: ttlSecondsAfterFinished is 10"; exit 0
fi
echo "Error: ttlSecondsAfterFinished is '$ttl', expected 10"; exit 1
