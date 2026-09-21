#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
vt=$(kubectl get pod data-transform -n phoenix -o jsonpath='{.spec.volumes[0].emptyDir}' 2>/dev/null)
if [ -n "$vt" ]; then
  echo "Success: emptyDir volume present"
  exit 0
else
  echo "Error: emptyDir volume not found"
  exit 1
fi
