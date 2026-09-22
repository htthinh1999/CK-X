#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
p=$(kubectl get deploy slow-app -n eclipse -o jsonpath='{.spec.template.spec.containers[0].startupProbe.httpGet.port}' 2>/dev/null)
if [ "$p" = "8080" ]; then
  echo "Success: startup probe port 8080"
  exit 0
else
  echo "Error: probe port is '$p'"
  exit 1
fi
