#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get job parallel-processor -n current -o jsonpath='{.spec.completions}' 2>/dev/null)
if [ "$val" = "6" ]; then echo "Success: completions is 6"; exit 0; else echo "Error: completions is '$val', expected 6"; exit 1; fi
