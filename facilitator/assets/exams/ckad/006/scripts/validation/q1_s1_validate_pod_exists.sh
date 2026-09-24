#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod metrics-pod -n delta >/dev/null 2>&1; then echo "Success: pod metrics-pod exists"; exit 0; else echo "Error: pod metrics-pod not found in delta"; exit 1; fi
