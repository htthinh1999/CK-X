#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
p=$(kubectl get deploy slow-app -n eclipse -o jsonpath='{.spec.template.spec.containers[0].startupProbe.httpGet.path}' 2>/dev/null)
if [ "$p" = "/healthz" ]; then
  echo "Success: startup probe path /healthz"
  exit 0
else
  echo "Error: probe path is '$p'"
  exit 1
fi
