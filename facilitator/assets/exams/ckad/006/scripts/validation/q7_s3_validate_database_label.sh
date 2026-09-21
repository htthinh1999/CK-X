#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pod database -n spring -o jsonpath='{.metadata.labels.role}' 2>/dev/null)
if [ "$v" = "db" ]; then echo "Success: database has role=db"; exit 0; else echo "Error: database role is '$v', expected db"; exit 1; fi
