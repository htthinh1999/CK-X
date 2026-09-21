#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
am=$(kubectl get pod stealth-pod -n siege -o jsonpath='{.spec.automountServiceAccountToken}' 2>/dev/null)
[ "$am" = "false" ] && { echo "Success: automountServiceAccountToken is false"; exit 0; }
echo "Error: automountServiceAccountToken is '$am', expected false"; exit 1
