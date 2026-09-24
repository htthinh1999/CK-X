#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pdb app-pdb -n hera -o jsonpath='{.spec.minAvailable}' 2>/dev/null)
if [ "$v" = "2" ]; then echo "Success: minAvailable 2"; exit 0; else echo "Error: minAvailable is '$v', expected 2"; exit 1; fi
