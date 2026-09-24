#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get pod cap-pod -n golden -o jsonpath='{.spec.containers[0].securityContext.capabilities.add}' 2>/dev/null)
case "$val" in
  *NET_ADMIN*) echo "Success: NET_ADMIN capability added"; exit 0 ;;
  *) echo "Error: NET_ADMIN capability missing (got '$val')"; exit 1 ;;
esac
