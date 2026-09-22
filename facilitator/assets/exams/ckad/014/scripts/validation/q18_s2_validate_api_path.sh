#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
paths=$(kubectl get ingress star-ingress -n starlight -o jsonpath='{range .spec.rules[*].http.paths[*]}{.path}{" "}{.backend.service.name}{"\n"}{end}' 2>/dev/null)
if echo "$paths" | grep -q "/api api-svc"; then
  echo "Success: /api path mapped to api-svc"
  exit 0
else
  echo "Error: /api path not mapped to api-svc"
  exit 1
fi
