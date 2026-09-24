#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
revision=$(helm history rollback-app -n wave --max 1 -o json 2>/dev/null | grep -o '"revision":[0-9]*' | head -1 | grep -o '[0-9]*')
if [ -n "$revision" ] && [ "$revision" -ge 3 ] 2>/dev/null; then
  echo "Success: rollback performed (current revision $revision)"
  exit 0
else
  echo "Error: no rollback detected (revision '$revision', expected >= 3)"
  exit 1
fi
