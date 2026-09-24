#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod dns-tester -n zenith >/dev/null 2>&1; then
  echo "Success: pod dns-tester exists in zenith"
  exit 0
fi
echo "Error: pod dns-tester not found in zenith"
exit 1
