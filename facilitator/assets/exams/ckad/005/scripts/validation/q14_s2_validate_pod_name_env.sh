#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod metadata-pod -n claw -o json 2>/dev/null | grep -q '"POD_NAME"'; then echo "Success: POD_NAME env present"; exit 0; else echo "Error: POD_NAME env not found"; exit 1; fi
