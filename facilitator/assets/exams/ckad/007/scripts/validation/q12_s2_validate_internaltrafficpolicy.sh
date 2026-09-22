#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get service local-svc -n ocean -o jsonpath='{.spec.internalTrafficPolicy}' 2>/dev/null)
if [ "$val" = "Local" ]; then echo "Success: internalTrafficPolicy is Local"; exit 0; else echo "Error: internalTrafficPolicy is '$val', expected Local"; exit 1; fi
