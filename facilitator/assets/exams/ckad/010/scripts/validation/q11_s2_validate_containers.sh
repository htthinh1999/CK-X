#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
c=$(kubectl get pod data-pod -n rice -o jsonpath='{.spec.containers[*].name}' 2>/dev/null)
case "$c" in
  *producer*consumer*|*consumer*producer*) echo "Success: producer and consumer present"; exit 0 ;;
  *) echo "Error: producer/consumer missing (got '$c')"; exit 1 ;;
esac
