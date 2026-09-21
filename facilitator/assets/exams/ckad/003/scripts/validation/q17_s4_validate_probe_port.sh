#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
p=$(kubectl get pod tcp-health -n ember -o jsonpath='{.spec.containers[0].livenessProbe.tcpSocket.port}' 2>/dev/null)
if [ "$p" = "80" ]; then
  echo "Success: probe port 80"
  exit 0
else
  echo "Error: probe port is '$p', expected 80"
  exit 1
fi
