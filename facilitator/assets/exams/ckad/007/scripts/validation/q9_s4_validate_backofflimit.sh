#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get job parallel-processor -n current -o jsonpath='{.spec.backoffLimit}' 2>/dev/null)
if [ "$val" = "4" ]; then echo "Success: backoffLimit is 4"; exit 0; else echo "Error: backoffLimit is '$val', expected 4"; exit 1; fi
