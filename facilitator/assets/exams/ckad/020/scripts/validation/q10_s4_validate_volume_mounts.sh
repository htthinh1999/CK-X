#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# containers + native sidecars (init containers with restartPolicy: Always)
vol_mounts=$(kubectl get pod data-transformer -n origin -o json 2>/dev/null | jq -r '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))] | map(.volumeMounts[]? | select(.name == "shared-data") | .mountPath) | join(" ")' 2>/dev/null)
if [[ "$vol_mounts" == *"/var/log"*"/var/log"* ]]; then
  echo "Success: shared-data mounted at /var/log in both containers"
  exit 0
fi
echo "Error: shared-data not mounted at /var/log in both containers (got '$vol_mounts')"
exit 1
