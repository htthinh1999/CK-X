#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pod hardened-pod -n predator -o jsonpath='{.spec.containers[0].securityContext.capabilities.drop[0]}' 2>/dev/null)
if [ "$v" = "ALL" ]; then echo "Success: capabilities drop ALL"; exit 0; else echo "Error: drop[0]='$v' expected ALL"; exit 1; fi
