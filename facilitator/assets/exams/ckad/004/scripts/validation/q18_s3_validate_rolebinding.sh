#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get rolebinding deploy-binding -n hermes >/dev/null 2>&1; then echo "Success: rolebinding deploy-binding exists"; exit 0; else echo "Error: rolebinding deploy-binding not found"; exit 1; fi
