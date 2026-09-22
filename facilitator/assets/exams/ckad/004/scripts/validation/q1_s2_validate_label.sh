#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pod titan-alpha -n zeus -o jsonpath='{.metadata.labels.app}' 2>/dev/null)
if [ "$v" = "titan" ]; then echo "Success: label app=titan"; exit 0; else echo "Error: label app is '$v', expected titan"; exit 1; fi
