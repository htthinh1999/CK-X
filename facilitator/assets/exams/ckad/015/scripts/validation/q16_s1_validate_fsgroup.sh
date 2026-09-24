#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl get pod secure-storage -n tempest >/dev/null 2>&1 || { echo "Error: Pod secure-storage not found in tempest"; exit 1; }
fsg=$(kubectl get pod secure-storage -n tempest -o jsonpath='{.spec.securityContext.fsGroup}' 2>/dev/null)
if [ "$fsg" == "2000" ]; then
  echo "Success: fsGroup is 2000"
  exit 0
else
  echo "Error: fsGroup='$fsg' (expected 2000)"
  exit 1
fi
