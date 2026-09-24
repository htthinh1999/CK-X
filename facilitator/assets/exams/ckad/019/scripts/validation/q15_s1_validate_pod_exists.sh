#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl get pod resource-aware -n fortress >/dev/null 2>&1 && { echo "Success: pod resource-aware exists"; exit 0; }
echo "Error: pod resource-aware not found"; exit 1
