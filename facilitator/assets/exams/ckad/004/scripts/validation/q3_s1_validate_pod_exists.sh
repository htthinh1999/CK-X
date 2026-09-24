#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod token-pod -n hades >/dev/null 2>&1; then echo "Success: pod token-pod exists"; exit 0; else echo "Error: pod token-pod not found in hades"; exit 1; fi
