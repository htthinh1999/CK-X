#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
replicas=$(kubectl get deployment glory-deploy -n glory -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$replicas" = "5" ]; then
  echo "Success: replicas is 5"
  exit 0
fi
echo "Error: replicas is '$replicas', expected 5"
exit 1
