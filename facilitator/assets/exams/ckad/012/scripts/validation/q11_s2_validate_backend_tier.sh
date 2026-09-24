#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pod backend -n rampart -o jsonpath='{.metadata.labels.tier}' 2>/dev/null)
if [ "$v" = "backend" ]; then echo "Success: pod backend has tier=backend"; exit 0
else echo "Error: pod backend tier is '$v', expected backend"; exit 1; fi
