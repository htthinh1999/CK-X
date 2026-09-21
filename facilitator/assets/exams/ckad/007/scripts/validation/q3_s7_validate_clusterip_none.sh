#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get service db-headless -n reef -o jsonpath='{.spec.clusterIP}' 2>/dev/null)
if [ "$val" = "None" ]; then echo "Success: clusterIP is None"; exit 0; else echo "Error: clusterIP is '$val', expected None"; exit 1; fi
