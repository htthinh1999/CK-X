#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
l=$(kubectl get deployment spread-pods -n tiger -o jsonpath='{.spec.template.metadata.labels.app}' 2>/dev/null)
if [ "$l" = "spread-pods" ]; then echo "Success: label app=spread-pods"; exit 0; else echo "Error: label app='$l' expected spread-pods"; exit 1; fi
