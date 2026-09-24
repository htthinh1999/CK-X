#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
n=$(kubectl get pod config-aggregator -n hunt -o jsonpath='{.spec.containers[0].name}' 2>/dev/null)
if [ "$n" = "aggregator" ]; then echo "Success: container named aggregator"; exit 0; else echo "Error: container='$n' expected aggregator"; exit 1; fi
