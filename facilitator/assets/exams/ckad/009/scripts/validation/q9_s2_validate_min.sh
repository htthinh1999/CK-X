#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

m=$(kubectl get hpa app-deploy -n root -o jsonpath='{.spec.minReplicas}' 2>/dev/null)
if [ "$m" = "5" ]; then
  echo "Success: minReplicas 5 correct"; exit 0
else
  echo "Error: minReplicas is '$m', expected 5"; exit 1
fi
