#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if ! kubectl get pod config-consumer -n tide >/dev/null 2>&1; then
  echo "Error: pod config-consumer not found in tide"; exit 1
fi
m=$(kubectl get pod config-consumer -n tide -o jsonpath='{.spec.containers[0].volumeMounts[*].mountPath}' 2>/dev/null)
if echo "$m" | grep -q "/etc/config"; then
  echo "Success: ConfigMap mounted at /etc/config"; exit 0
fi
echo "Error: mount path /etc/config not found (mounts: $m)"; exit 1
