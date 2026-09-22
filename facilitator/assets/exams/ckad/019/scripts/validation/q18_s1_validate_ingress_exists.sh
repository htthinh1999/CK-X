#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl get ingress canary-ingress -n sentinel >/dev/null 2>&1 && { echo "Success: ingress canary-ingress exists"; exit 0; }
echo "Error: ingress canary-ingress not found"; exit 1
