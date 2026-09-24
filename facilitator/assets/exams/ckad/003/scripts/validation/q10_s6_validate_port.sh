#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
p=$(kubectl get networkpolicy allow-from-flame -n corona -o jsonpath='{.spec.ingress[0].ports[0].port}' 2>/dev/null)
if [ "$p" = "80" ]; then
  echo "Success: allows port 80"
  exit 0
else
  echo "Error: port is '$p', expected 80"
  exit 1
fi
