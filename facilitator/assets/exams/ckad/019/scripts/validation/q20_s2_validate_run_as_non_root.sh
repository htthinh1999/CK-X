#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pod secure-workload -n bastion -o jsonpath='{.spec.securityContext.runAsNonRoot}' 2>/dev/null)
[ "$v" = "true" ] && { echo "Success: runAsNonRoot is true"; exit 0; }
echo "Error: runAsNonRoot is '$v', expected true"; exit 1
