#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get service db-headless -n reef >/dev/null 2>&1; then echo "Success: service db-headless exists in reef"; exit 0; else echo "Error: service db-headless not found in reef"; exit 1; fi
