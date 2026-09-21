#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl get job storm-processor -n breeze >/dev/null 2>&1 || { echo "Error: Job storm-processor not found in breeze"; exit 1; }
comps=$(kubectl get job storm-processor -n breeze -o jsonpath='{.spec.completions}' 2>/dev/null)
para=$(kubectl get job storm-processor -n breeze -o jsonpath='{.spec.parallelism}' 2>/dev/null)
if [ "$comps" == "6" ] && [ "$para" == "3" ]; then
  echo "Success: completions=6 parallelism=3"
  exit 0
else
  echo "Error: completions='$comps' parallelism='$para' (expected 6 / 3)"
  exit 1
fi
