#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get ingress api-ingress -n default >/dev/null 2>&1; then echo "Success: ingress api-ingress exists"; exit 0; else echo "Error: ingress api-ingress not found"; exit 1; fi
