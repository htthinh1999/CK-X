#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod metadata-pod -n claw -o json 2>/dev/null | grep -q '"NODE_NAME"'; then echo "Success: NODE_NAME env present"; exit 0; else echo "Error: NODE_NAME env not found"; exit 1; fi
