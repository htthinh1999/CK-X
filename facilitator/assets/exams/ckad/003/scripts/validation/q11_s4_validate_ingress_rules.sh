#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
ing=$(kubectl get networkpolicy allow-from-flame -n corona -o jsonpath='{.spec.ingress}' 2>/dev/null)
if [ -n "$ing" ] && [ "$ing" != "[]" ]; then
  echo "Success: ingress rules defined"
  exit 0
else
  echo "Error: no ingress rules defined"
  exit 1
fi
