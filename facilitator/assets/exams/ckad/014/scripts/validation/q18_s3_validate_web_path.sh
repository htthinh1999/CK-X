#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
paths=$(kubectl get ingress star-ingress -n starlight -o jsonpath='{range .spec.rules[*].http.paths[*]}{.path}{" "}{.backend.service.name}{"\n"}{end}' 2>/dev/null)
if echo "$paths" | grep -q "/web web-svc"; then
  echo "Success: /web path mapped to web-svc"
  exit 0
else
  echo "Error: /web path not mapped to web-svc"
  exit 1
fi
