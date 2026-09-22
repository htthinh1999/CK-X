#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pod secure-pod -n stalker -o jsonpath='{.spec.securityContext.runAsUser}' 2>/dev/null)
if [ "$v" = "1000" ]; then echo "Success: runAsUser 1000"; exit 0; else echo "Error: runAsUser='$v' expected 1000"; exit 1; fi
