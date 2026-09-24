#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
endp=$(kubectl get netpol port-range-allow -n chorus -o jsonpath='{.spec.ingress[0].ports[0].endPort}' 2>/dev/null)
if [ "$endp" == "3010" ]; then
  echo "Success: ingress endPort is 3010"; exit 0
fi
echo "Error: endPort is '$endp', expected 3010"; exit 1
