#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
sel=$(kubectl get svc zephyr-svc -n zephyr -o jsonpath='{.spec.selector.version}' 2>/dev/null)
if [ "$sel" == "green" ]; then
  echo "Success: zephyr-svc selector version=green"
  exit 0
else
  echo "Error: zephyr-svc selector version='$sel' (expected green)"
  exit 1
fi
