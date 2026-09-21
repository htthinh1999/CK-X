#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
n=$(kubectl get networkpolicy allow-from-flame -n corona -o json 2>/dev/null | grep -c "namespaceSelector")
if [ "$n" -gt 0 ] 2>/dev/null; then
  echo "Success: uses namespaceSelector"
  exit 0
else
  echo "Error: namespaceSelector not used"
  exit 1
fi
