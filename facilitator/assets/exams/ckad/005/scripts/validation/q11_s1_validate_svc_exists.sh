#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get service backend-svc -n claw >/dev/null 2>&1; then echo "Success: service backend-svc exists"; exit 0; else echo "Error: service backend-svc not found"; exit 1; fi
