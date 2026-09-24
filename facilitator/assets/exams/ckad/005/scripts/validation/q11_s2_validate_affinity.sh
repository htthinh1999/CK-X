#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get service backend-svc -n claw -o jsonpath='{.spec.sessionAffinity}' 2>/dev/null)
if [ "$v" = "ClientIP" ]; then echo "Success: sessionAffinity ClientIP"; exit 0; else echo "Error: sessionAffinity='$v' expected ClientIP"; exit 1; fi
