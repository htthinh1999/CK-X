#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod spread-pod -n eddy >/dev/null 2>&1; then echo "Success: pod spread-pod exists"; exit 0; else echo "Error: pod spread-pod not found in eddy"; exit 1; fi
