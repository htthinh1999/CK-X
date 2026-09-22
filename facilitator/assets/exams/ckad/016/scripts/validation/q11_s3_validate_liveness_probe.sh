#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
p=$(kubectl get pod complex-app -n plasma -o jsonpath='{.spec.containers[0].livenessProbe}' 2>/dev/null)
if [ -n "$p" ]; then echo "Success: liveness probe configured"; exit 0; fi
echo "Error: liveness probe not configured"; exit 1
