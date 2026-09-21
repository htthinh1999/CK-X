#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
mp=$(kubectl get pod config-reader -n flame -o jsonpath='{.spec.containers[0].volumeMounts[?(@.name=="cm-vol")].mountPath}' 2>/dev/null)
if [ -z "$mp" ]; then
  mp=$(kubectl get pod config-reader -n flame -o json 2>/dev/null | grep -oP '"/config/?"' | head -1 | tr -d '"')
fi
if echo "$mp" | grep -qE '^/config/?$'; then
  echo "Success: volume mounted at /config"
  exit 0
else
  echo "Error: volume not mounted at /config (found '$mp')"
  exit 1
fi
