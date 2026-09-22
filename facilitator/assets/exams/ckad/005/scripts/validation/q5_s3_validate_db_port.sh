#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get configmap locked-config -n hunt -o jsonpath='{.data.DB_PORT}' 2>/dev/null)
if [ "$v" = "5432" ]; then echo "Success: DB_PORT=5432"; exit 0; else echo "Error: DB_PORT='$v' expected 5432"; exit 1; fi
