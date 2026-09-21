#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
vol_mounts=$(kubectl get pod data-transformer -n origin -o jsonpath='{.spec.containers[*].volumeMounts[?(@.name=="shared-data")].mountPath}' 2>/dev/null)
if [[ "$vol_mounts" == *"/var/log"*"/var/log"* ]]; then
  echo "Success: shared-data mounted at /var/log in both containers"
  exit 0
fi
echo "Error: shared-data not mounted at /var/log in both containers (got '$vol_mounts')"
exit 1
