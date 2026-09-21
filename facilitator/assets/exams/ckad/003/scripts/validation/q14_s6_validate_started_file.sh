#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl exec lifecycle-pod -n phoenix -c main -- test -f /usr/share/nginx/html/started.txt 2>/dev/null; then
  echo "Success: started.txt created by postStart hook"
  exit 0
else
  echo "Error: /usr/share/nginx/html/started.txt not found in container"
  exit 1
fi
