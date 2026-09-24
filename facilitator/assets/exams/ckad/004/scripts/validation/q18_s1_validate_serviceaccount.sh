#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get serviceaccount deployment-manager -n hermes >/dev/null 2>&1; then echo "Success: serviceaccount deployment-manager exists"; exit 0; else echo "Error: serviceaccount deployment-manager not found"; exit 1; fi
