#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deploy broken-app -n default >/dev/null 2>&1; then echo "Success: deployment broken-app exists"; exit 0; else echo "Error: deployment broken-app not found"; exit 1; fi
