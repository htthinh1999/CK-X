#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get hpa web-app-hpa -n ocean -o jsonpath='{.spec.minReplicas}' 2>/dev/null)
if [ "$val" = "2" ]; then echo "Success: minReplicas is 2"; exit 0; else echo "Error: minReplicas is '$val', expected 2"; exit 1; fi
