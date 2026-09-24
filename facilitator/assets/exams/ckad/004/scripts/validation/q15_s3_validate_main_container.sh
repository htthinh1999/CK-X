#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pod multi-init -n poseidon -o jsonpath='{.spec.containers[0].name}' 2>/dev/null)
if [ "$v" = "app" ]; then echo "Success: main container app"; exit 0; else echo "Error: main container is '$v', expected app"; exit 1; fi
