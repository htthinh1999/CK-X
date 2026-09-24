#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
rep=$(kubectl get deploy vanguard-web -n vanguard -o jsonpath='{.spec.replicas}' 2>/dev/null)
[ "$rep" = "5" ] && { echo "Success: replicas is 5"; exit 0; }
echo "Error: replicas is '$rep', expected 5"; exit 1
