#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
w=$(kubectl get ingress canary-ingress -n sentinel -o jsonpath='{.metadata.annotations.nginx\.ingress\.kubernetes\.io/canary-weight}' 2>/dev/null)
[ "$w" = "20" ] && { echo "Success: canary-weight is 20"; exit 0; }
echo "Error: canary-weight is '$w', expected 20"; exit 1
