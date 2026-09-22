#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

up=$(kubectl get pod secure-pod -n valley -o jsonpath='{.spec.securityContext.runAsUser}' 2>/dev/null)
uc=$(kubectl get pod secure-pod -n valley -o jsonpath='{.spec.containers[0].securityContext.runAsUser}' 2>/dev/null)
if [ "$up" = "101" ] || [ "$uc" = "101" ]; then echo "Success: runAsUser is 101"; exit 0; else echo "Error: runAsUser pod=$up container=$uc"; exit 1; fi
