#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get service local-svc -n ocean >/dev/null 2>&1; then echo "Success: service local-svc exists in ocean"; exit 0; else echo "Error: service local-svc not found in ocean"; exit 1; fi
