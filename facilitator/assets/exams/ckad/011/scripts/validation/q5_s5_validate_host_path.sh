#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
hp=$(kubectl get pv sea-pv -o jsonpath='{.spec.hostPath.path}' 2>/dev/null)
if [ "$hp" = "/data/sea" ]; then
  echo "Success: host path is /data/sea"
  exit 0
else
  echo "Error: host path is '$hp', expected /data/sea"
  exit 1
fi
