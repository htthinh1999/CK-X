#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get clusterrolebinding node-reader-binding -o yaml 2>/dev/null | grep -q "node-monitor-sa"; then echo "Success: binding to SA"; exit 0; else echo "Error: binding to SA - not found"; exit 1; fi
