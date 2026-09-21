#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
pol=$(kubectl get svc local-app-svc -n aria -o jsonpath='{.spec.externalTrafficPolicy}' 2>/dev/null)
if [ "$pol" == "Local" ]; then
  echo "Success: externalTrafficPolicy is Local"; exit 0
fi
echo "Error: externalTrafficPolicy is '$pol', expected Local"; exit 1
