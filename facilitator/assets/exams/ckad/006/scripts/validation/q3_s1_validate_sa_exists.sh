#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get sa log-sa -n marsh >/dev/null 2>&1; then echo "Success: serviceaccount log-sa exists"; exit 0; else echo "Error: serviceaccount log-sa not found in marsh"; exit 1; fi
