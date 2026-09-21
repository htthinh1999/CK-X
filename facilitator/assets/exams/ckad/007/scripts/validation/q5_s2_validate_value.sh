#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get priorityclass critical-priority -o jsonpath='{.value}' 2>/dev/null)
if [ "$val" = "1000000" ]; then echo "Success: value is 1000000"; exit 0; else echo "Error: value is '$val', expected 1000000"; exit 1; fi
