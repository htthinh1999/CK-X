#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get service db-headless -n reef -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
if [ "$val" = "6379" ]; then echo "Success: service port is 6379"; exit 0; else echo "Error: service port is '$val', expected 6379"; exit 1; fi
