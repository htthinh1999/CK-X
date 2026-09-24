#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
rev=$(kubectl rollout history deployment/web-deploy -n tide 2>/dev/null | tail -1 | awk '{print $1}')
if [ -n "$rev" ] && [ "$rev" -ge 4 ] 2>/dev/null; then
  echo "Success: rollout undo performed (current revision $rev)"
  exit 0
else
  echo "Error: no rollout undo detected (revision '$rev', expected >= 4)"
  exit 1
fi
