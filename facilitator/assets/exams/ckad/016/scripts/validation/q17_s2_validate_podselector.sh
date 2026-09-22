#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
ps=$(kubectl get networkpolicy strict-ingress -n charge -o jsonpath='{.spec.podSelector.matchLabels.role}' 2>/dev/null)
if [ "$ps" = "db" ]; then echo "Success: podSelector role=db"; exit 0; fi
echo "Error: podSelector role is '$ps', expected db"; exit 1
