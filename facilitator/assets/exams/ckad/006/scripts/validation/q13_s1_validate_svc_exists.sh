#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get svc api-nodeport -n default >/dev/null 2>&1; then echo "Success: service api-nodeport exists"; exit 0; else echo "Error: service api-nodeport not found"; exit 1; fi
