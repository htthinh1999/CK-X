#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
m=$(kubectl get pod web-with-sidecar -n corona -o jsonpath='{range .spec.containers[*]}{.volumeMounts}{"\n"}{end}' 2>/dev/null | grep -c "log-volume\|/var/log/nginx")
if [ "$m" -ge 2 ]; then
  echo "Success: both containers mount shared volume"
  exit 0
else
  echo "Error: only $m/2 containers mount the shared volume"
  exit 1
fi
