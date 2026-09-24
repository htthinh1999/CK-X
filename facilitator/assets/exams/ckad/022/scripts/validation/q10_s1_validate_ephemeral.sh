#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
eph=$(kubectl get pod distroless-pod -n apex -o jsonpath='{.spec.ephemeralContainers}' 2>/dev/null)
if [ -n "$eph" ] && [ "$eph" != "[]" ]; then
  echo "Success: ephemeral container found on distroless-pod"
  exit 0
fi
echo "Error: no ephemeral container found on distroless-pod"
exit 1
