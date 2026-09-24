#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
t=$(kubectl get secret registry-creds -n radiance -o jsonpath='{.type}' 2>/dev/null)
if [ "$t" = "kubernetes.io/dockerconfigjson" ]; then
  echo "Success: type dockerconfigjson"
  exit 0
else
  echo "Error: type is '$t'"
  exit 1
fi
