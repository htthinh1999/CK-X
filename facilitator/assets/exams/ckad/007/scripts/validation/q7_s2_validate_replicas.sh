#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get deployment web-frontend -n coral -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$val" = "3" ]; then echo "Success: replicas is 3"; exit 0; else echo "Error: replicas is '$val', expected 3"; exit 1; fi
