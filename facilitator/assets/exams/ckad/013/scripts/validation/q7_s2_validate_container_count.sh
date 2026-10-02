#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# containers + native sidecars (init containers with restartPolicy: Always)
c=$(kubectl get pod web-with-sidecar -n corona -o json 2>/dev/null | jq '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))] | length' 2>/dev/null)
c=${c:-0}
if [ "$c" -ge 2 ]; then
  echo "Success: pod has $c containers (incl. native sidecars)"
  exit 0
else
  echo "Error: pod has $c containers incl. native sidecars (expected >=2)"
  exit 1
fi
