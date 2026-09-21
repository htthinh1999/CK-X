#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
tp=$(kubectl get service backend-headless -n corona -o jsonpath='{.spec.ports[0].targetPort}' 2>/dev/null)
if [ "$tp" = "80" ]; then
  echo "Success: targetPort 80"
  exit 0
else
  echo "Error: targetPort is '$tp', expected 80"
  exit 1
fi
