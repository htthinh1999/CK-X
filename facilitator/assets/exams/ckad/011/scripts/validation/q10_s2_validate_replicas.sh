#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
replicas=$(kubectl get deployment -n tide -l app.kubernetes.io/instance=my-release -o jsonpath='{.items[0].spec.replicas}' 2>/dev/null)
if [ "$replicas" = "2" ]; then
  echo "Success: replicaCount is 2"
  exit 0
else
  echo "Error: replicaCount is '$replicas', expected 2"
  exit 1
fi
