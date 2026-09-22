#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
ph=$(kubectl get pod data-processor -n sentinel -o jsonpath='{.status.phase}' 2>/dev/null)
[ "$ph" = "Running" ] && { echo "Success: pod data-processor is Running"; exit 0; }
echo "Error: pod phase is '$ph', expected Running"; exit 1
