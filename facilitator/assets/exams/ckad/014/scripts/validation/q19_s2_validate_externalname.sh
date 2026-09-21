#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
type=$(kubectl get svc db-ext-svc -n nebula -o jsonpath='{.spec.type}' 2>/dev/null)
ext=$(kubectl get svc db-ext-svc -n nebula -o jsonpath='{.spec.externalName}' 2>/dev/null)
if [ "$type" == "ExternalName" ] && [ "$ext" == "database.external.example.com" ]; then
  echo "Success: type ExternalName and externalName correct"
  exit 0
else
  echo "Error: type='$type', externalName='$ext'"
  exit 1
fi
