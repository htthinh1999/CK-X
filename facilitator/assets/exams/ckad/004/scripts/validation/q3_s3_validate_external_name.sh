#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get svc external-api -n hermes -o jsonpath='{.spec.externalName}' 2>/dev/null)
if [ "$v" = "api.external-service.com" ]; then echo "Success: externalName correct"; exit 0; else echo "Error: externalName is '$v', expected api.external-service.com"; exit 1; fi
