#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
dc=$(kubectl get secret registry-creds -n radiance -o jsonpath='{.data.\.dockerconfigjson}' 2>/dev/null | base64 -d 2>/dev/null)
if [[ "$dc" == *"registry.example.com"* ]]; then
  echo "Success: server registry.example.com present"
  exit 0
else
  echo "Error: server registry.example.com not found"
  exit 1
fi
