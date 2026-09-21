#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
cmd=$(kubectl get pod entry-override -n fortress -o jsonpath='{.spec.containers[0].command[0]}' 2>/dev/null)
[ "$cmd" = "sleep" ] && { echo "Success: command[0] is sleep"; exit 0; }
echo "Error: command[0] is '$cmd', expected sleep"; exit 1
