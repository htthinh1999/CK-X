#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
arg=$(kubectl get pod entry-override -n fortress -o jsonpath='{.spec.containers[0].args[0]}' 2>/dev/null)
[ "$arg" = "3600" ] && { echo "Success: args[0] is 3600"; exit 0; }
echo "Error: args[0] is '$arg', expected 3600"; exit 1
