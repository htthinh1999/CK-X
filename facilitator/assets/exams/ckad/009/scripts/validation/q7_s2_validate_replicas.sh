#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

r=$(kubectl get deployment app-deploy -n root -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$r" = "3" ] || [ "$r" = "5" ]; then
  echo "Success: replicas correct ($r)"; exit 0
else
  echo "Error: replicas is '$r', expected 3 or 5"; exit 1
fi
