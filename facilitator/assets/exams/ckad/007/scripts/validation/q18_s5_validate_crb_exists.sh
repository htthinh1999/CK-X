#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get clusterrolebinding node-reader-binding >/dev/null 2>&1; then echo "Success: clusterrolebinding node-reader-binding exists"; exit 0; else echo "Error: clusterrolebinding node-reader-binding not found"; exit 1; fi
