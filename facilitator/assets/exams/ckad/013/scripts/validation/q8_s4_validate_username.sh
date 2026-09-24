#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
dc=$(kubectl get secret registry-creds -n radiance -o jsonpath='{.data.\.dockerconfigjson}' 2>/dev/null | base64 -d 2>/dev/null)
if [[ "$dc" == *"admin"* ]]; then
  echo "Success: username admin present"
  exit 0
else
  echo "Error: username admin not found"
  exit 1
fi
