#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
t=$(kubectl get service sticky-svc -n flash -o jsonpath='{.spec.sessionAffinityConfig.clientIP.timeoutSeconds}' 2>/dev/null)
if [ "$t" = "10800" ]; then echo "Success: timeout 10800"; exit 0; fi
echo "Error: timeout is '$t', expected 10800"; exit 1
