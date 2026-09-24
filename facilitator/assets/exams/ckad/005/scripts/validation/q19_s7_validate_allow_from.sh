#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get networkpolicy allow-frontend-to-api -n predator -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.tier}' 2>/dev/null)
if [ "$v" = "frontend" ]; then echo "Success: allows from tier=frontend"; exit 0; else echo "Error: ingress from tier='$v' expected frontend"; exit 1; fi
