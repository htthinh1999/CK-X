#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
h=$(kubectl get ingress rewrite-ingress -n ocean -o jsonpath='{.spec.rules[0].host}' 2>/dev/null)
if [ "$h" = "susanoo.com" ]; then
  echo "Success: host is susanoo.com"; exit 0
fi
echo "Error: host is '$h', expected susanoo.com"; exit 1
