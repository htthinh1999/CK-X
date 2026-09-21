#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get networkpolicy allow-frontend-to-api -n predator >/dev/null 2>&1; then echo "Success: networkpolicy allow-frontend-to-api exists"; exit 0; else echo "Error: networkpolicy allow-frontend-to-api not found"; exit 1; fi
