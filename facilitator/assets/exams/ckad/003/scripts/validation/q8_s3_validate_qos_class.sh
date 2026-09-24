#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
q=$(kubectl get pod qos-guaranteed -n spark -o jsonpath='{.status.qosClass}' 2>/dev/null)
if [ "$q" = "Guaranteed" ]; then
  echo "Success: QoS Guaranteed"
  exit 0
else
  echo "Error: QoS class is '$q', expected Guaranteed"
  exit 1
fi
