#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get ingress path-ingress -n poseidon >/dev/null 2>&1; then echo "Success: ingress path-ingress exists"; exit 0; else echo "Error: ingress path-ingress not found in poseidon"; exit 1; fi
