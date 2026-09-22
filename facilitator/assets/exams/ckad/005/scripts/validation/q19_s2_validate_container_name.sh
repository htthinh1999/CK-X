#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pod graceful-pod -n tiger -o jsonpath='{.spec.containers[0].name}' 2>/dev/null)
if [ "$v" = "main" ]; then echo "Success: container named main"; exit 0; else echo "Error: container='$v' expected main"; exit 1; fi
