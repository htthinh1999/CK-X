#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pod web-with-sidecar -n corona -o jsonpath='{.spec.volumes}' 2>/dev/null)
if [[ "$v" == *"emptyDir"* ]]; then
  echo "Success: emptyDir volume configured"
  exit 0
else
  echo "Error: emptyDir volume missing"
  exit 1
fi
