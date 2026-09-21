#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get service external-api -n fang -o jsonpath='{.spec.type}' 2>/dev/null)
if [ "$v" = "ExternalName" ]; then echo "Success: type ExternalName"; exit 0; else echo "Error: type='$v' expected ExternalName"; exit 1; fi
