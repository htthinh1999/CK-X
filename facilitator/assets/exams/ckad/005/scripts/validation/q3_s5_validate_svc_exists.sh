#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get service web-service -n stripe >/dev/null 2>&1; then echo "Success: service web-service exists"; exit 0; else echo "Error: service web-service not found"; exit 1; fi
