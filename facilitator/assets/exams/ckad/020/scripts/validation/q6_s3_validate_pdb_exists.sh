#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pdb terra-pdb -n terra >/dev/null 2>&1; then
  echo "Success: PodDisruptionBudget terra-pdb exists in terra"
  exit 0
fi
echo "Error: PodDisruptionBudget terra-pdb not found in terra"
exit 1
