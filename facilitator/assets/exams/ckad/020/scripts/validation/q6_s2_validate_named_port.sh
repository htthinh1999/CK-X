#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
port=$(kubectl get networkpolicy allow-named-port -n matrix -o jsonpath='{.spec.ingress[0].ports[0].port}' 2>/dev/null)
if [ "$port" = "api-port" ]; then
  echo "Success: ingress rule uses named port api-port"
  exit 0
fi
echo "Error: ingress port is '$port', expected api-port"
exit 1
