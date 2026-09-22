#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
conts=$(kubectl get pod legacy-app -n eclipse -o jsonpath='{range .spec.containers[*]}{.name}{" "}{.image}{"\n"}{end}' 2>/dev/null)
if echo "$conts" | grep -q "backend nginx:1.25"; then
  echo "Success: backend container correct (backend nginx:1.25)"
  exit 0
else
  echo "Error: backend container (backend nginx:1.25) not found"
  exit 1
fi
