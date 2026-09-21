#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
y=$(kubectl get networkpolicy api-allow -n sunbeam -o yaml 2>/dev/null)
c=$(kubectl get networkpolicy api-allow -n sunbeam -o jsonpath='{.spec.ingress[0].from[*].ipBlock.cidr}' 2>/dev/null)
if echo "$y" | grep -q "ipBlock" && [[ "$c" == *"10.0.0.0/24"* ]]; then
  echo "Success: ipBlock 10.0.0.0/24 present"
  exit 0
else
  echo "Error: ipBlock rule missing or CIDR is '$c'"
  exit 1
fi
