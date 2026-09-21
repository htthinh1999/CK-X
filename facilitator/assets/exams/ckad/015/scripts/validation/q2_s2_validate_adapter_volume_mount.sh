#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
mnt=$(kubectl get pod wind-logger -n gale -o jsonpath='{.spec.containers[?(@.name=="adapter")].volumeMounts[?(@.mountPath=="/var/log")].name}' 2>/dev/null)
if [ "$mnt" == "logs" ]; then
  echo "Success: adapter mounts volume 'logs' at /var/log"
  exit 0
else
  echo "Error: adapter volume 'logs' not mounted at /var/log (got '$mnt')"
  exit 1
fi
