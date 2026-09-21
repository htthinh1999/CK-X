#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get ingress mastery-ing -n mastery >/dev/null 2>&1; then
  echo "Success: ingress mastery-ing exists in mastery"
  exit 0
fi
echo "Error: ingress mastery-ing not found in mastery"
exit 1
