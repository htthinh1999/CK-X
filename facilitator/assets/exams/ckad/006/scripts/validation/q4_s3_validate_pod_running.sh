#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pod metrics-pod -n delta -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$v" = "Running" ]; then echo "Success: pod metrics-pod is Running"; exit 0; else echo "Error: pod phase is '$v', expected Running"; exit 1; fi
