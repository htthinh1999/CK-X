#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod troubled-app -n anchor >/dev/null 2>&1; then echo "Success: pod troubled-app exists in anchor"; exit 0; else echo "Error: pod troubled-app not found in anchor"; exit 1; fi
