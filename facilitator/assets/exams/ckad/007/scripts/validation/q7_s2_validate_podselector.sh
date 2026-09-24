#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get networkpolicy external-access -n wave -o jsonpath='{.spec.podSelector.matchLabels.tier}' 2>/dev/null | grep -q "api"; then echo "Success: podSelector tier api"; exit 0; else echo "Error: podSelector tier api - not found"; exit 1; fi
