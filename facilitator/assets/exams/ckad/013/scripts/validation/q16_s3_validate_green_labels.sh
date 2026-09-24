#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
a=$(kubectl get deploy app-green -n flare -o jsonpath='{.spec.template.metadata.labels.app}' 2>/dev/null)
v=$(kubectl get deploy app-green -n flare -o jsonpath='{.spec.template.metadata.labels.version}' 2>/dev/null)
if [ "$a" = "webapp" ] && [ "$v" = "green" ]; then
  echo "Success: green labels app=webapp version=green"
  exit 0
else
  echo "Error: labels app='$a' version='$v'"
  exit 1
fi
