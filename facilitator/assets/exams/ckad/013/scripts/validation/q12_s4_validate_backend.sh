#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
n=$(kubectl get ingress secure-ingress -n solstice -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.name}' 2>/dev/null)
p=$(kubectl get ingress secure-ingress -n solstice -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.port.number}' 2>/dev/null)
if [ "$n" = "secure-svc" ] && [ "$p" = "443" ]; then
  echo "Success: backend secure-svc:443"
  exit 0
else
  echo "Error: backend '$n':'$p'"
  exit 1
fi
