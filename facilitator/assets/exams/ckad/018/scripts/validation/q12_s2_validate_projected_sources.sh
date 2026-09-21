#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
proj=$(kubectl get pod projected-pod -n melody -o jsonpath='{.spec.volumes[?(@.projected)].projected.sources}' 2>/dev/null)
if [[ "$proj" == *"downwardAPI"* ]] && [[ "$proj" == *"configMap"* ]] && [[ "$proj" == *"secret"* ]]; then
  echo "Success: projected volume has downwardAPI, configMap and secret sources"; exit 0
fi
echo "Error: projected volume sources incomplete"; exit 1
