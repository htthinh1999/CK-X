#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod config-aggregator -n hunt -o json 2>/dev/null | grep -q "serviceAccountToken"; then echo "Success: projected volume has serviceAccountToken"; exit 0; else echo "Error: serviceAccountToken not found"; exit 1; fi
