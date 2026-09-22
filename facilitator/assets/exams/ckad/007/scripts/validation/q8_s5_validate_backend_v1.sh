#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get ingress api-routing -n lagoon -o yaml 2>/dev/null | grep -q "api-v1-svc"; then echo "Success: backend api-v1-svc"; exit 0; else echo "Error: backend api-v1-svc - not found"; exit 1; fi
