#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
mp=$(kubectl get pod pvc-pod -n depths -o jsonpath='{.spec.containers[0].volumeMounts[0].mountPath}' 2>/dev/null)
mp="${mp%/}"
if [ "$mp" = "/data" ]; then
  echo "Success: mount path is /data"
  exit 0
else
  echo "Error: mount path is '$mp', expected /data"
  exit 1
fi
