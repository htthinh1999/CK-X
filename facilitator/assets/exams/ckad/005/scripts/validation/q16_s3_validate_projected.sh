#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pod config-aggregator -n hunt -o jsonpath='{.spec.volumes[?(@.name=="combined-config")].projected}' 2>/dev/null)
if [ -n "$v" ]; then echo "Success: projected volume combined-config exists"; exit 0; else echo "Error: projected volume combined-config not found"; exit 1; fi
