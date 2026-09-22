#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
target=$(kubectl get hpa api-hpa -n refuge -o jsonpath='{.spec.scaleTargetRef.name}' 2>/dev/null)
if [[ "$target" == "api-server" ]]; then
  echo "Success: HPA targets api-server"
  exit 0
fi
echo "Error: HPA target is '$target', expected api-server"
exit 1
