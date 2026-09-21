#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
eph=$(kubectl get pod target-pod -n reef -o jsonpath='{.spec.ephemeralContainers[0].name}' 2>/dev/null)
if [ -n "$eph" ]; then
  echo "Success: ephemeral container '$eph' attached to target-pod"; exit 0
fi
echo "Error: no ephemeral container found on target-pod"; exit 1
