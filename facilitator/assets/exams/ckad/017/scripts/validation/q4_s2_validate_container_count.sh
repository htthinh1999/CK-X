#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# count containers + native sidecars (init containers with restartPolicy: Always)
c=$(kubectl get pod log-generator -n tide -o json 2>/dev/null | jq '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))] | length' 2>/dev/null)
if [ "$c" -ge 2 ] 2>/dev/null; then
  echo "Success: pod has $c containers (sidecar present)"; exit 0
fi
echo "Error: pod does not have a sidecar (containers=$c)"; exit 1
