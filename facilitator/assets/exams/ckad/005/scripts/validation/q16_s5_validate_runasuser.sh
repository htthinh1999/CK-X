#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pod hardened-pod -n predator -o jsonpath='{.spec.containers[0].securityContext.runAsUser}' 2>/dev/null)
if [ "$v" = "101" ]; then echo "Success: runAsUser 101"; exit 0; else echo "Error: runAsUser='$v' expected 101"; exit 1; fi
