#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
a=$(kubectl get service sticky-svc -n flash -o jsonpath='{.spec.sessionAffinity}' 2>/dev/null)
if [ "$a" = "ClientIP" ]; then echo "Success: sessionAffinity ClientIP"; exit 0; fi
echo "Error: sessionAffinity is '$a', expected ClientIP"; exit 1
