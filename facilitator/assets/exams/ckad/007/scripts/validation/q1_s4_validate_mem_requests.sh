#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get resourcequota namespace-limits -n shell -o jsonpath='{.spec.hard.requests\.memory}' 2>/dev/null)
if [ "$val" = "4Gi" ]; then echo "Success: requests.memory limit is 4Gi"; exit 0; else echo "Error: requests.memory limit is '$val', expected 4Gi"; exit 1; fi
