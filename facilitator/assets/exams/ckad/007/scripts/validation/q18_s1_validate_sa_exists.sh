#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get serviceaccount node-monitor-sa -n lagoon >/dev/null 2>&1; then echo "Success: serviceaccount node-monitor-sa exists in lagoon"; exit 0; else echo "Error: serviceaccount node-monitor-sa not found in lagoon"; exit 1; fi
