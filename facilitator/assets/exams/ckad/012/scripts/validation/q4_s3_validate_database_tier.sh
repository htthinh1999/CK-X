#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pod database -n rampart -o jsonpath='{.metadata.labels.tier}' 2>/dev/null)
if [ "$v" = "database" ]; then echo "Success: pod database has tier=database"; exit 0
else echo "Error: pod database tier is '$v', expected database"; exit 1; fi
