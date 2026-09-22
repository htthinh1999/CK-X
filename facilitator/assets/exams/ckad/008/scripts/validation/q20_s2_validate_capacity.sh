#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

v=$(kubectl get pv myvolume -o jsonpath='{.spec.capacity.storage}' 2>/dev/null)
if [ "$v" = "10Gi" ]; then
  echo "Success: PV capacity is 10Gi"; exit 0
else
  echo "Error: PV capacity is '$v', expected 10Gi"; exit 1
fi
