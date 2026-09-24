#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if ! kubectl get pod logger -n lunar >/dev/null 2>&1; then
  echo "Error: pod logger not found in lunar"
  exit 1
fi
count=$(kubectl get pod logger -n lunar -o jsonpath='{range .spec.containers[*]}{.name}{"\n"}{end}' 2>/dev/null | grep -c .)
if [ "$count" == "2" ]; then
  echo "Success: pod logger has two containers"
  exit 0
else
  echo "Error: pod logger has '$count' containers, expected 2"
  exit 1
fi
