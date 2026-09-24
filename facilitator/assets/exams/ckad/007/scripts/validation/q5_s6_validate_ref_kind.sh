#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get hpa web-app-hpa -n ocean -o jsonpath='{.spec.scaleTargetRef.kind}' 2>/dev/null)
if [ "$val" = "Deployment" ]; then echo "Success: scaleTargetRef.kind is Deployment"; exit 0; else echo "Error: scaleTargetRef.kind is '$val', expected Deployment"; exit 1; fi
