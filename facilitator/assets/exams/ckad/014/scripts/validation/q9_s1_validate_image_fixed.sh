#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if ! kubectl get pod metrics-gatherer -n starlight >/dev/null 2>&1; then
  echo "Error: pod metrics-gatherer not found in starlight"
  exit 1
fi
img=$(kubectl get pod metrics-gatherer -n starlight -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
# Source criterion: image must no longer be the broken/non-existent one.
if [ -n "$img" ] && [[ "$img" != *"non-existent"* ]] && [[ "$img" != *"nginxxxxx"* ]]; then
  echo "Success: image corrected to '$img'"
  exit 0
else
  echo "Error: image still broken ('$img')"
  exit 1
fi
