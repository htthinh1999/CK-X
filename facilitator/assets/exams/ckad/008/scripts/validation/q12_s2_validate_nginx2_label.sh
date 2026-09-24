#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

v=$(kubectl get pod nginx2 -n ridge -o jsonpath='{.metadata.labels.app}' 2>/dev/null)
if [ "$v" = "v2" ]; then
  echo "Success: nginx2 app label is v2"; exit 0
else
  echo "Error: nginx2 app label is '$v', expected v2"; exit 1
fi
