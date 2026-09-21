#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
node=$(kubectl get pod direct-pod -n coral -o jsonpath='{.spec.nodeName}' 2>/dev/null)
if [ -n "$node" ]; then
  echo "Success: nodeName is set to $node"
  exit 0
else
  echo "Error: nodeName not set on direct-pod"
  exit 1
fi
