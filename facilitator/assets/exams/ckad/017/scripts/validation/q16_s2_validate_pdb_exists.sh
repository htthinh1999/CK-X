#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pdb critical-pdb -n lagoon >/dev/null 2>&1; then
  echo "Success: PDB critical-pdb exists in lagoon"; exit 0
fi
echo "Error: PDB critical-pdb not found in lagoon"; exit 1
