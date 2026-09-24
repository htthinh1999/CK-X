#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get deployment patch-demo -n tide -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$val" = "4" ]; then echo "Success: replicas is 4"; exit 0; else echo "Error: replicas is '$val', expected 4"; exit 1; fi
