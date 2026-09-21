#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

c=$(kubectl get hpa app-deploy -n root -o jsonpath='{.spec.metrics[0].resource.target.averageUtilization}' 2>/dev/null)
if [ "$c" = "80" ]; then
  echo "Success: CPU target 80% correct"; exit 0
else
  echo "Error: CPU target is '$c', expected 80"; exit 1
fi
