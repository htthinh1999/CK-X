#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
r=$(kubectl get deployment backend-v2 -n spark -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$r" = "1" ]; then echo "Success: replicas is 1"; exit 0; fi
echo "Error: replicas is '$r', expected 1"; exit 1
