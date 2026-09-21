#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get pod cap-pod -n golden -o jsonpath='{.spec.containers[0].securityContext.capabilities.add}' 2>/dev/null)
case "$val" in
  *SYS_TIME*) echo "Success: SYS_TIME capability added"; exit 0 ;;
  *) echo "Error: SYS_TIME capability missing (got '$val')"; exit 1 ;;
esac
