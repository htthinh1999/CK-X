#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
p=$(kubectl get pod complex-app -n plasma -o jsonpath='{.spec.containers[0].readinessProbe}' 2>/dev/null)
if [ -n "$p" ]; then echo "Success: readiness probe configured"; exit 0; fi
echo "Error: readiness probe not configured"; exit 1
