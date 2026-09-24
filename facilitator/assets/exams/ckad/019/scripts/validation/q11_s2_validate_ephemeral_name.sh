#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
name=$(kubectl get pod secure-app -n outpost -o jsonpath='{.spec.ephemeralContainers[0].name}' 2>/dev/null)
[ "$name" = "debugger" ] && { echo "Success: ephemeral container named debugger"; exit 0; }
echo "Error: ephemeral container name is '$name', expected debugger"; exit 1
