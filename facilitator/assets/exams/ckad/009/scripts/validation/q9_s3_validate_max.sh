#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

m=$(kubectl get hpa app-deploy -n root -o jsonpath='{.spec.maxReplicas}' 2>/dev/null)
if [ "$m" = "10" ]; then
  echo "Success: maxReplicas 10 correct"; exit 0
else
  echo "Error: maxReplicas is '$m', expected 10"; exit 1
fi
