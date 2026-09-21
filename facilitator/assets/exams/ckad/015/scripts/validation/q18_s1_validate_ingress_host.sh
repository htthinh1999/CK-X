#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl get ingress tornado-ingress -n tornado >/dev/null 2>&1 || { echo "Error: Ingress tornado-ingress not found in tornado"; exit 1; }
host=$(kubectl get ingress tornado-ingress -n tornado -o jsonpath='{.spec.rules[0].host}' 2>/dev/null)
if [ "$host" == "tornado.dojo.com" ]; then
  echo "Success: ingress host tornado.dojo.com"
  exit 0
else
  echo "Error: rules[0].host='$host' (expected tornado.dojo.com)"
  exit 1
fi
