#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pod frontend -n rampart -o jsonpath='{.metadata.labels.tier}' 2>/dev/null)
if [ "$v" = "frontend" ]; then echo "Success: pod frontend has tier=frontend"; exit 0
else echo "Error: pod frontend tier is '$v', expected frontend"; exit 1; fi
