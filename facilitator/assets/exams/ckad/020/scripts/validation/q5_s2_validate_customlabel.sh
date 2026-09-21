#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if ! helm status genesis-web -n nexus >/dev/null 2>&1; then
  echo "Error: helm release genesis-web not found in nexus"
  exit 1
fi
label=$(helm get values genesis-web -n nexus -a 2>/dev/null | grep -A 0 'customLabel:' | awk '{print $2}')
if [ "$label" = "initial-install" ]; then
  echo "Success: customLabel retained as initial-install"
  exit 0
fi
echo "Error: customLabel is '$label', expected initial-install"
exit 1
