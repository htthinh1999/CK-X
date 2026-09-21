#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
cn=$(kubectl get pod data-pod -n aurora -o jsonpath='{.spec.volumes[0].persistentVolumeClaim.claimName}' 2>/dev/null)
if [ "$cn" = "app-data-pvc" ]; then
  echo "Success: pod uses PVC app-data-pvc"
  exit 0
else
  echo "Error: claimName is '$cn'"
  exit 1
fi
