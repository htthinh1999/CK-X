#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get hpa web-app-hpa -n ocean -o jsonpath='{.spec.maxReplicas}' 2>/dev/null)
if [ "$val" = "10" ]; then echo "Success: maxReplicas is 10"; exit 0; else echo "Error: maxReplicas is '$val', expected 10"; exit 1; fi
