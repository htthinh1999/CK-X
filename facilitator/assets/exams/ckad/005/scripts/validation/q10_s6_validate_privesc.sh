#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pod secure-pod -n stalker -o jsonpath='{.spec.containers[0].securityContext.allowPrivilegeEscalation}' 2>/dev/null)
if [ "$v" = "false" ]; then echo "Success: allowPrivilegeEscalation false"; exit 0; else echo "Error: allowPrivilegeEscalation='$v' expected false"; exit 1; fi
