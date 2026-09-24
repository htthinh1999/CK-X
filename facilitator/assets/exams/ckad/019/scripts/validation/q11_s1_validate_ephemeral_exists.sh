#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
cnt=$(kubectl get pod secure-app -n outpost -o jsonpath='{range .spec.ephemeralContainers[*]}{.name}{"\n"}{end}' 2>/dev/null | grep -c .)
[ "$cnt" -ge 1 ] && { echo "Success: ephemeral container present"; exit 0; }
echo "Error: no ephemeral container found on secure-app"; exit 1
