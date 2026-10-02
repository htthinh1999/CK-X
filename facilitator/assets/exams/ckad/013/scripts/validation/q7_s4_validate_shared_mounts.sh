#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# one line of volumeMounts per container, native sidecars (init containers with restartPolicy: Always) included
m=$(kubectl get pod web-with-sidecar -n corona -o json 2>/dev/null | jq -c '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))][] | .volumeMounts' 2>/dev/null | grep -c "log-volume\|/var/log/nginx")
if [ "$m" -ge 2 ]; then
  echo "Success: both containers mount shared volume"
  exit 0
else
  echo "Error: only $m/2 containers mount the shared volume"
  exit 1
fi
