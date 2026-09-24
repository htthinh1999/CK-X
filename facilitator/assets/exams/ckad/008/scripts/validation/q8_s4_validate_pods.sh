#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

v=$(kubectl get quota cliff-quota -n cliff -o jsonpath='{.spec.hard.pods}' 2>/dev/null)
if [ "$v" = "2" ]; then
  echo "Success: pods limit is 2"; exit 0
else
  echo "Error: pods limit is '$v', expected 2"; exit 1
fi
