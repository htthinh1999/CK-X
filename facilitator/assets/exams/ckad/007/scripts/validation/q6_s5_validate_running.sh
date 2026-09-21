#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get pod slow-starter -n wave -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$val" = "Running" ]; then echo "Success: pod phase is Running"; exit 0; else echo "Error: pod phase is '$val', expected Running"; exit 1; fi
