#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
conts=$(kubectl get pod legacy-app -n eclipse -o jsonpath='{range .spec.containers[*]}{.name}{" "}{.image}{"\n"}{end}' 2>/dev/null)
if echo "$conts" | grep -q "proxy haproxy:2.8-alpine"; then
  echo "Success: proxy container correct (proxy haproxy:2.8-alpine)"
  exit 0
else
  echo "Error: proxy container (proxy haproxy:2.8-alpine) not found"
  exit 1
fi
