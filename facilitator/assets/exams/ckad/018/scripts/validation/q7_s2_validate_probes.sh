#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
live=$(kubectl get pod health-check -n harmony -o jsonpath='{.spec.containers[0].livenessProbe}' 2>/dev/null)
read_p=$(kubectl get pod health-check -n harmony -o jsonpath='{.spec.containers[0].readinessProbe}' 2>/dev/null)
if [[ -n "$live" ]] && [[ -n "$read_p" ]]; then
  echo "Success: pod has both liveness and readiness probes"; exit 0
fi
echo "Error: missing probes (liveness='$live' readiness='$read_p')"; exit 1
