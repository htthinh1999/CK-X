#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
rep=$(kubectl get deploy battle-web-battle-chart -n garrison -o jsonpath='{.spec.replicas}' 2>/dev/null)
[ "$rep" = "3" ] && { echo "Success: replicas is 3"; exit 0; }
echo "Error: replicas is '$rep', expected 3"; exit 1
