#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get clusterrole node-reader -o yaml 2>/dev/null | grep -q "namespaces"; then echo "Success: namespaces permission"; exit 0; else echo "Error: namespaces permission - not found"; exit 1; fi
