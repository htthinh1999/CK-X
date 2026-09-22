#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get priorityclass critical-priority >/dev/null 2>&1; then echo "Success: priorityclass critical-priority exists"; exit 0; else echo "Error: priorityclass critical-priority not found"; exit 1; fi
