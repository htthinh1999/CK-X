#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get resourcequota namespace-limits -n shell -o jsonpath='{.spec.hard.pods}' 2>/dev/null)
if [ "$val" = "10" ]; then echo "Success: pods limit is 10"; exit 0; else echo "Error: pods limit is '$val', expected 10"; exit 1; fi
