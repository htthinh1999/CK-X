#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get secret db-credentials -n stream -o jsonpath='{.data.DB_PASS}' 2>/dev/null)
if [ -n "$val" ]; then echo "Success: secret has DB_PASS key"; exit 0; else echo "Error: secret missing DB_PASS key"; exit 1; fi
