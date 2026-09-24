#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get deployment rolling-app -n apollo -o jsonpath='{.spec.strategy.rollingUpdate.maxSurge}' 2>/dev/null)
if [ "$v" = "25%" ]; then echo "Success: maxSurge 25%"; exit 0; else echo "Error: maxSurge is '$v', expected 25%"; exit 1; fi
