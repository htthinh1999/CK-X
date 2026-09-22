#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get secret db-credentials -n stream >/dev/null 2>&1; then echo "Success: secret db-credentials exists"; exit 0; else echo "Error: secret db-credentials not found in stream"; exit 1; fi
