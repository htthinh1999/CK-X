#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get ingress api-routing -n lagoon -o yaml 2>/dev/null | grep -q "/v2"; then echo "Success: path /v2"; exit 0; else echo "Error: path /v2 - not found"; exit 1; fi
