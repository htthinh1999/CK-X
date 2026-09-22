#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
sel=$(kubectl get service frontend-svc -n blaze -o jsonpath='{.spec.selector}' 2>/dev/null)
if echo "$sel" | grep -q "web-frontend" && ! echo "$sel" | grep -q "version"; then
  echo "Success: service selects app=web-frontend without version (routes to both)"
  exit 0
else
  echo "Error: service selector '$sel' must match web-frontend and not include version"
  exit 1
fi
