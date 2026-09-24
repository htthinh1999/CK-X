#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get priorityclass critical-priority -o jsonpath='{.globalDefault}' 2>/dev/null)
if [ "$val" != "true" ]; then echo "Success: globalDefault is not true (got '$val')"; exit 0; else echo "Error: globalDefault is true"; exit 1; fi
