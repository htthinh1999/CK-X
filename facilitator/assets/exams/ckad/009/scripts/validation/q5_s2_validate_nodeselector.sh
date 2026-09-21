#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

sel=$(kubectl get pod gpu-pod -n fern -o jsonpath='{.spec.nodeSelector.accelerator}' 2>/dev/null)
if [ "$sel" = "nvidia" ]; then
  echo "Success: nodeSelector accelerator=nvidia correct"; exit 0
else
  echo "Error: nodeSelector accelerator is '$sel', expected nvidia"; exit 1
fi
