#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get hpa web-app-hpa -n ocean -o jsonpath='{.spec.scaleTargetRef.name}' 2>/dev/null)
if [ "$val" = "web-app" ]; then echo "Success: scaleTargetRef.name is web-app"; exit 0; else echo "Error: scaleTargetRef.name is '$val', expected web-app"; exit 1; fi
