#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# adapter may be a regular container or a native sidecar (init container with restartPolicy: Always)
mnt=$(kubectl get pod wind-logger -n gale -o json 2>/dev/null | jq -r '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))][] | select(.name == "adapter") | .volumeMounts[]? | select(.mountPath == "/var/log") | .name' 2>/dev/null)
if [ "$mnt" == "logs" ]; then
  echo "Success: adapter mounts volume 'logs' at /var/log"
  exit 0
else
  echo "Error: adapter volume 'logs' not mounted at /var/log (got '$mnt')"
  exit 1
fi
