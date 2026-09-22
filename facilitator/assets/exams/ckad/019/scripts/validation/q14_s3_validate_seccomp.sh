#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pod secure-workload -n bastion -o jsonpath='{.spec.securityContext.seccompProfile.type}' 2>/dev/null)
[ "$v" = "RuntimeDefault" ] && { echo "Success: seccompProfile is RuntimeDefault"; exit 0; }
echo "Error: seccompProfile type is '$v', expected RuntimeDefault"; exit 1
