#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
port=$(kubectl get ingress cosmos-ingress -n cosmos -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.port.number}' 2>/dev/null)
if [ "$port" = "80" ]; then
  echo "Success: backend service port is 80"
  exit 0
fi
echo "Error: backend service port is '$port', expected 80"
exit 1
