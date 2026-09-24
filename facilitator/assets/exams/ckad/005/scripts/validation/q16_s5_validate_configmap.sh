#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod config-aggregator -n hunt -o json 2>/dev/null | grep -q '"configMap"'; then echo "Success: projected volume has configMap"; exit 0; else echo "Error: configMap source not found"; exit 1; fi
