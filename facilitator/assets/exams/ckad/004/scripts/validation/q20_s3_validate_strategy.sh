#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get deployment rolling-app -n apollo -o jsonpath='{.spec.strategy.type}' 2>/dev/null)
if [ "$v" = "RollingUpdate" ]; then echo "Success: strategy RollingUpdate"; exit 0; else echo "Error: strategy is '$v', expected RollingUpdate"; exit 1; fi
