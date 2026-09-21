#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pod frontend -n spring -o jsonpath='{.metadata.labels.role}' 2>/dev/null)
if [ "$v" = "frontend" ]; then echo "Success: frontend has role=frontend"; exit 0; else echo "Error: frontend role is '$v', expected frontend"; exit 1; fi
