#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get resourcequota namespace-limits -n shell -o jsonpath='{.spec.hard.requests\.cpu}' 2>/dev/null)
if [ "$val" = "4" ]; then echo "Success: requests.cpu limit is 4"; exit 0; else echo "Error: requests.cpu limit is '$val', expected 4"; exit 1; fi
