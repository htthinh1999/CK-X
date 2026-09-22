#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get secret db-credentials -n fortress -o jsonpath='{.data.DB_USER}' 2>/dev/null)
if [ -n "$v" ]; then echo "Success: Secret key DB_USER present"; exit 0
else echo "Error: Secret key DB_USER missing"; exit 1; fi
