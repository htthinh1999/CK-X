#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod adapter-pod -n zeus >/dev/null 2>&1; then echo "Success: pod adapter-pod exists"; exit 0; else echo "Error: pod adapter-pod not found in zeus"; exit 1; fi
