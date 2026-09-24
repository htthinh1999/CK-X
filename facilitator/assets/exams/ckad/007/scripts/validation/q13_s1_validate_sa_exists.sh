#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get serviceaccount app-deployer -n current >/dev/null 2>&1; then echo "Success: serviceaccount app-deployer exists in current"; exit 0; else echo "Error: serviceaccount app-deployer not found in current"; exit 1; fi
