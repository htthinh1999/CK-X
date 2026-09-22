#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl get pod secret-reader -n gale >/dev/null 2>&1 || { echo "Error: Pod secret-reader not found in gale"; exit 1; }
sub=$(kubectl get pod secret-reader -n gale -o jsonpath='{.spec.containers[0].volumeMounts[0].subPath}' 2>/dev/null)
if [ "$sub" == "password.txt" ]; then
  echo "Success: subPath password.txt configured"
  exit 0
else
  echo "Error: volumeMounts[0].subPath='$sub' (expected password.txt)"
  exit 1
fi
