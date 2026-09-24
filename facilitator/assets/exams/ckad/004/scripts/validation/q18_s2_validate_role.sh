#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get role deploy-role -n hermes >/dev/null 2>&1; then echo "Success: role deploy-role exists"; exit 0; else echo "Error: role deploy-role not found"; exit 1; fi
