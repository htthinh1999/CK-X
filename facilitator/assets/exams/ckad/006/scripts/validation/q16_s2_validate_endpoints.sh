#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get endpoints web-svc -n shoal -o jsonpath='{.subsets[0].addresses}' 2>/dev/null)
if [ -n "$v" ]; then echo "Success: service web-svc has endpoints"; exit 0; else echo "Error: service web-svc has no endpoints"; exit 1; fi
