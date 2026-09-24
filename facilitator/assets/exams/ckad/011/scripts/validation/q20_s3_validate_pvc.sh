#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
claim=$(kubectl get pod pvc-pod -n depths -o jsonpath='{.spec.volumes[?(@.persistentVolumeClaim)].persistentVolumeClaim.claimName}' 2>/dev/null)
if [ "$claim" = "sea-pvc" ]; then
  echo "Success: PVC sea-pvc is mounted"
  exit 0
else
  echo "Error: mounted claim is '$claim', expected sea-pvc"
  exit 1
fi
