#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
cnt=$(kubectl get ep backend-svc -n parapet -o jsonpath='{.subsets[0].addresses}' 2>/dev/null | grep -c "ip" 2>/dev/null || echo "0")
if [ "$cnt" -ge 1 ] 2>/dev/null; then echo "Success: backend-svc has endpoints"; exit 0
else echo "Error: backend-svc has no endpoints"; exit 1; fi
