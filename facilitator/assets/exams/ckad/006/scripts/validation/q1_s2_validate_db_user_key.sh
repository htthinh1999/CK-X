#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get secret db-credentials -n stream -o jsonpath='{.data.DB_USER}' 2>/dev/null)
if [ -n "$val" ]; then echo "Success: secret has DB_USER key"; exit 0; else echo "Error: secret missing DB_USER key"; exit 1; fi
