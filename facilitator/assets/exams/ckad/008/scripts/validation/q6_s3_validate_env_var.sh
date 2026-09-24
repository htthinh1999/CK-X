#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

val=$(kubectl get pod envpod -n summit -o jsonpath='{.spec.containers[0].env[?(@.name=="VAR1")].value}' 2>/dev/null)
if [ "$val" = "value1" ]; then echo "Success: VAR1=value1"; exit 0; else echo "Error: VAR1 is '$val'"; exit 1; fi
