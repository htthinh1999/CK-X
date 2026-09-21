#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get clusterrole node-reader -o yaml 2>/dev/null | grep -q "nodes"; then echo "Success: nodes permission"; exit 0; else echo "Error: nodes permission - not found"; exit 1; fi
