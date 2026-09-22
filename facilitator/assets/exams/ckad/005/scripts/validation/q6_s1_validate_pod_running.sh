#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
p=$(kubectl get pod config-aggregator -n hunt -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$p" = "Running" ]; then echo "Success: pod config-aggregator running"; exit 0; else echo "Error: pod phase='$p' expected Running"; exit 1; fi
