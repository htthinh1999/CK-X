#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get hpa web-app-hpa -n ocean -o jsonpath='{.spec.metrics[0].resource.target.averageUtilization}' 2>/dev/null)
if [ "$val" = "70" ]; then echo "Success: target averageUtilization is 70"; exit 0; else echo "Error: target averageUtilization is '$val', expected 70"; exit 1; fi
