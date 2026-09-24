#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
lbl=$(kubectl get clusterrole monitor-viewer -o jsonpath='{.metadata.labels}' 2>/dev/null)
if [ -n "$lbl" ] && [ "$lbl" != "map[]" ] && [ "$lbl" != "{}" ]; then
  echo "Success: monitor-viewer has labels"
  exit 0
fi
echo "Error: monitor-viewer has no labels"
exit 1
