#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
min=$(kubectl get pdb terra-pdb -n terra -o jsonpath='{.spec.minAvailable}' 2>/dev/null)
if [ "$min" = "75%" ]; then
  echo "Success: PDB minAvailable is 75%"
  exit 0
fi
echo "Error: PDB minAvailable is '$min', expected 75%"
exit 1
