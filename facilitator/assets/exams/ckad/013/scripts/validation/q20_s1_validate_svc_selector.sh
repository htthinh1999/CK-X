#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
s=$(kubectl get svc dns-svc -n sunbeam -o jsonpath='{.spec.selector.app}' 2>/dev/null)
if [ "$s" = "dns-app" ]; then
  echo "Success: service selector app=dns-app"
  exit 0
else
  echo "Error: service selector app='$s'"
  exit 1
fi
