#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
anno=$(kubectl get service topology-service -n anchor -o jsonpath='{.metadata.annotations}' 2>/dev/null)
if [[ "$anno" == *"topology"* ]]; then
  echo "Success: topology annotation present"
  exit 0
fi
echo "Error: topology annotation missing"
exit 1
