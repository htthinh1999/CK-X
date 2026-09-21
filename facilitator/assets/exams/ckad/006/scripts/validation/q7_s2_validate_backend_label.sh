#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pod backend -n spring -o jsonpath='{.metadata.labels.role}' 2>/dev/null)
if [ "$v" = "backend" ]; then echo "Success: backend has role=backend"; exit 0; else echo "Error: backend role is '$v', expected backend"; exit 1; fi
