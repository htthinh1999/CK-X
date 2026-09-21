#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get secret db-credentials -n fortress -o jsonpath='{.data.DB_PASS}' 2>/dev/null)
if [ -n "$v" ]; then echo "Success: Secret key DB_PASS present"; exit 0
else echo "Error: Secret key DB_PASS missing"; exit 1; fi
