#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
reps=$(kubectl get deployment terra-web -n terra -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$reps" = "4" ]; then
  echo "Success: terra-web has 4 replicas"
  exit 0
fi
echo "Error: terra-web replicas is '$reps', expected 4"
exit 1
