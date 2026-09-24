#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get statefulset db-cluster -n reef -o jsonpath='{.spec.serviceName}' 2>/dev/null)
if [ "$val" = "db-headless" ]; then echo "Success: serviceName is db-headless"; exit 0; else echo "Error: serviceName is '$val', expected db-headless"; exit 1; fi
