#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get pod live-pod -n shrine -o jsonpath='{.spec.containers[0].livenessProbe.exec.command}' 2>/dev/null)
case "$val" in
  *ls*) echo "Success: liveness exec command includes ls"; exit 0 ;;
  *) echo "Error: liveness exec command missing ls (got '$val')"; exit 1 ;;
esac
