#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
mp=$(kubectl get pod sidecar-pod -n abyss -o jsonpath='{.spec.containers[0].volumeMounts[0].mountPath}' 2>/dev/null)
mp="${mp%/}"
if [ "$mp" = "/logs" ]; then
  echo "Success: volume mounted at /logs"
  exit 0
else
  echo "Error: volume mount path is '$mp', expected /logs"
  exit 1
fi
