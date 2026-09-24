#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get rolebinding pod-reader-binding -n bastion -o jsonpath='{.subjects[0].name}' 2>/dev/null)
if [ "$val" = "pod-reader-sa" ]; then
  echo "Success: RoleBinding subject ServiceAccount ($val)"
  exit 0
else
  echo "Error: RoleBinding subject ServiceAccount - got '$val', expected 'pod-reader-sa'"
  exit 1
fi
