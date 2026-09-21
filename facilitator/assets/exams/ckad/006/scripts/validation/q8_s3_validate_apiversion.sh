#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get deploy broken-app -n default -o jsonpath='{.apiVersion}' 2>/dev/null)
if [ "$v" = "apps/v1" ]; then echo "Success: broken-app uses apps/v1"; exit 0; else echo "Error: apiVersion is '$v', expected apps/v1"; exit 1; fi
