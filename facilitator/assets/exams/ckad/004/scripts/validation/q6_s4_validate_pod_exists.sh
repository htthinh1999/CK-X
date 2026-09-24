#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod config-reader -n athena >/dev/null 2>&1; then echo "Success: pod config-reader exists"; exit 0; else echo "Error: pod config-reader not found"; exit 1; fi
