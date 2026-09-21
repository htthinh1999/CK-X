#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get service external-api -n fang -o jsonpath='{.spec.externalName}' 2>/dev/null)
if [ "$v" = "api.external-service.com" ]; then echo "Success: externalName correct"; exit 0; else echo "Error: externalName='$v' expected api.external-service.com"; exit 1; fi
