#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
rep=$(kubectl get deploy weapon-smith -n armory -o jsonpath='{.spec.replicas}' 2>/dev/null)
[ "$rep" = "3" ] && { echo "Success: replicas is 3"; exit 0; }
echo "Error: replicas is '$rep', expected 3"; exit 1
