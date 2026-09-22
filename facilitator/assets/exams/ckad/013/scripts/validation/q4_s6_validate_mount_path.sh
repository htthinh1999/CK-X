#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
mp=$(kubectl get pod data-pod -n aurora -o jsonpath='{.spec.containers[0].volumeMounts[0].mountPath}' 2>/dev/null)
mp="${mp%/}"
if [ "$mp" = "/usr/share/nginx/html" ]; then
  echo "Success: mounted at /usr/share/nginx/html"
  exit 0
else
  echo "Error: mount path is '$mp'"
  exit 1
fi
