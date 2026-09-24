#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deployment stable-green -n stripe >/dev/null 2>&1; then echo "Success: deployment stable-green exists"; exit 0; else echo "Error: deployment stable-green not found"; exit 1; fi
