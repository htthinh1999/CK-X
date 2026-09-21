#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get rolebinding pod-reader-binding -n bastion -o jsonpath='{.roleRef.name}' 2>/dev/null)
if [ "$val" = "pod-reader-role" ]; then
  echo "Success: RoleBinding roleRef name ($val)"
  exit 0
else
  echo "Error: RoleBinding roleRef name - got '$val', expected 'pod-reader-role'"
  exit 1
fi
