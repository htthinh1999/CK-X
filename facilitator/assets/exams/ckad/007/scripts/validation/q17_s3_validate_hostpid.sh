#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get pod network-diagnostic -n coral -o jsonpath='{.spec.hostPID}' 2>/dev/null)
if [ "$val" = "true" ]; then echo "Success: hostPID is true"; exit 0; else echo "Error: hostPID is '$val', expected true"; exit 1; fi
