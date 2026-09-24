#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get limitrange resource-limits -n apollo -o jsonpath='{.spec.limits[0].default.cpu}' 2>/dev/null)
if [ "$v" = "500m" ]; then echo "Success: default cpu 500m"; exit 0; else echo "Error: default cpu is '$v', expected 500m"; exit 1; fi
