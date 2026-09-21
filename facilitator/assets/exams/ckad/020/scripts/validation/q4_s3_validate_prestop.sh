#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
prestop=$(kubectl get pod graceful-shutdown -n ancient -o jsonpath='{.spec.containers[0].lifecycle.preStop.exec.command}' 2>/dev/null)
if [ -n "$prestop" ]; then
  echo "Success: preStop exec hook is configured"
  exit 0
fi
echo "Error: preStop exec hook not found"
exit 1
