#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get service backend-svc -n claw -o jsonpath='{.spec.sessionAffinityConfig.clientIP.timeoutSeconds}' 2>/dev/null)
if [ "$v" = "3600" ]; then echo "Success: timeout 3600"; exit 0; else echo "Error: timeoutSeconds='$v' expected 3600"; exit 1; fi
