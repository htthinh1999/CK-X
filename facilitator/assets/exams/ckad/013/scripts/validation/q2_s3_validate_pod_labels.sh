#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
a=$(kubectl get deploy frontend-app -n solar -o jsonpath='{.spec.template.metadata.labels.app}' 2>/dev/null)
t=$(kubectl get deploy frontend-app -n solar -o jsonpath='{.spec.template.metadata.labels.tier}' 2>/dev/null)
if [ "$a" = "frontend" ] && [ "$t" = "web" ]; then
  echo "Success: pod labels app=frontend tier=web"
  exit 0
else
  echo "Error: labels app='$a' tier='$t'"
  exit 1
fi
