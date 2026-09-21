#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
vol=$(kubectl get pod sidecar-pod -n abyss -o jsonpath='{.spec.volumes[0].name}' 2>/dev/null)
ed=$(kubectl get pod sidecar-pod -n abyss -o jsonpath='{.spec.volumes[0].emptyDir}' 2>/dev/null)
if [ -n "$vol" ] && [ -n "$ed" ]; then
  echo "Success: emptyDir volume '$vol' exists"
  exit 0
else
  echo "Error: emptyDir volume not found (name='$vol', emptyDir='$ed')"
  exit 1
fi
