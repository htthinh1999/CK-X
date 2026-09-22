#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
reps=$(helm get values guardian-app -n haven -o json 2>/dev/null | grep replicaCount | grep -o '"replicaCount":[0-9]*' | grep -o '[0-9]*')
if [[ "$reps" == "3" ]]; then
  echo "Success: replicaCount is 3"
  exit 0
fi
echo "Error: replicaCount is '$reps', expected 3"
exit 1
