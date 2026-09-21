#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
cm=$(kubectl get pod config-reader -n flame -o jsonpath='{.spec.volumes[0].configMap.name}' 2>/dev/null)
if [ "$cm" = "app-settings" ]; then
  echo "Success: uses ConfigMap app-settings"
  exit 0
else
  echo "Error: configMap name is '$cm', expected app-settings"
  exit 1
fi
