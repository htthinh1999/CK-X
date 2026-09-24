#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pod hardened-pod -n predator -o jsonpath='{.spec.containers[0].securityContext.capabilities.add[0]}' 2>/dev/null)
if [ "$v" = "NET_BIND_SERVICE" ]; then echo "Success: capabilities add NET_BIND_SERVICE"; exit 0; else echo "Error: add[0]='$v' expected NET_BIND_SERVICE"; exit 1; fi
