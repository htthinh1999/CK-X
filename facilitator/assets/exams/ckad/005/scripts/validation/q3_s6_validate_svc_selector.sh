#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
s=$(kubectl get service web-service -n stripe -o jsonpath='{.spec.selector.version}' 2>/dev/null)
if [ "$s" = "green" ]; then echo "Success: selector targets version=green"; exit 0; else echo "Error: selector version='$s' expected green"; exit 1; fi
