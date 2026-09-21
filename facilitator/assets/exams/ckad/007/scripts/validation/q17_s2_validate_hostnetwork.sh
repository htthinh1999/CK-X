#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get pod network-diagnostic -n coral -o jsonpath='{.spec.hostNetwork}' 2>/dev/null)
if [ "$val" = "true" ]; then echo "Success: hostNetwork is true"; exit 0; else echo "Error: hostNetwork is '$val', expected true"; exit 1; fi
