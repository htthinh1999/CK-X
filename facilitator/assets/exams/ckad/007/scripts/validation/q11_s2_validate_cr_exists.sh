#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get clusterrole node-reader >/dev/null 2>&1; then echo "Success: clusterrole node-reader exists"; exit 0; else echo "Error: clusterrole node-reader not found"; exit 1; fi
