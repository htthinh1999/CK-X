#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get networkpolicy allow-frontend-to-api -n predator -o jsonpath='{.spec.podSelector.matchLabels.tier}' 2>/dev/null)
if [ "$v" = "backend" ]; then echo "Success: targets tier=backend"; exit 0; else echo "Error: podSelector tier='$v' expected backend"; exit 1; fi
