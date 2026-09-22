#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
t=$(kubectl get pod tcp-health -n ember -o jsonpath='{.spec.containers[0].livenessProbe.tcpSocket}' 2>/dev/null)
if [ -n "$t" ]; then
  echo "Success: tcpSocket liveness probe present"
  exit 0
else
  echo "Error: tcpSocket liveness probe not found"
  exit 1
fi
