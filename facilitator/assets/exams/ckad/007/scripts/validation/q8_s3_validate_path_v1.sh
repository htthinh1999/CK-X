#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get ingress api-routing -n lagoon -o yaml 2>/dev/null | grep -q "/v1"; then echo "Success: path /v1"; exit 0; else echo "Error: path /v1 - not found"; exit 1; fi
