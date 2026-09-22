#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
liveness=$(kubectl get pod monitored-pod -n ward -o jsonpath='{.spec.containers[0].livenessProbe}' 2>/dev/null)
readiness=$(kubectl get pod monitored-pod -n ward -o jsonpath='{.spec.containers[0].readinessProbe}' 2>/dev/null)
startup=$(kubectl get pod monitored-pod -n ward -o jsonpath='{.spec.containers[0].startupProbe}' 2>/dev/null)
if [[ -n "$liveness" ]] && [[ -n "$readiness" ]] && [[ -n "$startup" ]]; then
  echo "Success: liveness, readiness and startup probes present"
  exit 0
fi
echo "Error: one or more probes missing"
exit 1
