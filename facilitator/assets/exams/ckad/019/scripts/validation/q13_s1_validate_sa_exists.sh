#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl get serviceaccount stealth-sa -n siege >/dev/null 2>&1 && { echo "Success: sa stealth-sa exists"; exit 0; }
echo "Error: serviceaccount stealth-sa not found"; exit 1
