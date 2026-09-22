#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get endpoints backend-svc -n claw -o jsonpath='{.subsets[0].addresses}' 2>/dev/null)
if [ -n "$v" ]; then echo "Success: service has endpoints"; exit 0; else echo "Error: service has no endpoints"; exit 1; fi
