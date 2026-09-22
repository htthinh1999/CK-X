#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
t=$(kubectl get deployment spread-pods -n tiger -o json 2>/dev/null | grep -o '"topologyKey"[^,]*' | head -1)
if echo "$t" | grep -q "kubernetes.io/hostname"; then echo "Success: topologyKey is kubernetes.io/hostname"; exit 0; else echo "Error: topologyKey not kubernetes.io/hostname"; exit 1; fi
