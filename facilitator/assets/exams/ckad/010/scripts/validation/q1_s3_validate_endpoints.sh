#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get ep web -n harvest -o jsonpath='{.subsets[0].addresses[0].ip}' 2>/dev/null)
if [ -n "$val" ]; then
  echo "Success: Service web has endpoints"
  exit 0
else
  echo "Error: Service web has no endpoints"
  exit 1
fi
