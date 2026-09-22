#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get statefulset db-cluster -n reef >/dev/null 2>&1; then echo "Success: statefulset db-cluster exists in reef"; exit 0; else echo "Error: statefulset db-cluster not found in reef"; exit 1; fi
