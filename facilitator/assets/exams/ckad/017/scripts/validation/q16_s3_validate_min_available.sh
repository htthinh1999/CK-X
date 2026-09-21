#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
m=$(kubectl get pdb critical-pdb -n lagoon -o jsonpath='{.spec.minAvailable}' 2>/dev/null)
if [ "$m" = "2" ]; then
  echo "Success: minAvailable is 2"; exit 0
fi
echo "Error: minAvailable is '$m', expected 2"; exit 1
