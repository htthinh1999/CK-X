#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
c=$(kubectl get pod log-generator -n tide -o jsonpath='{range .spec.containers[*]}{.name}{" "}{end}' 2>/dev/null | wc -w)
if [ "$c" -ge 2 ] 2>/dev/null; then
  echo "Success: pod has $c containers (sidecar present)"; exit 0
fi
echo "Error: pod does not have a sidecar (containers=$c)"; exit 1
