#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pod resource-pod -n pond -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$v" = "Running" ]; then echo "Success: pod resource-pod is Running"; exit 0; else echo "Error: pod phase is '$v', expected Running"; exit 1; fi
