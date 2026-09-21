#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get configmap locked-config -n hunt -o jsonpath='{.data.DB_HOST}' 2>/dev/null)
if [ "$v" = "postgres.hunt.svc" ]; then echo "Success: DB_HOST correct"; exit 0; else echo "Error: DB_HOST='$v' expected postgres.hunt.svc"; exit 1; fi
