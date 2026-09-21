#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
d=$(kubectl get pod secure-net -n bolt -o jsonpath='{.spec.containers[0].securityContext.capabilities.drop[0]}' 2>/dev/null)
if [ "$d" = "ALL" ]; then echo "Success: dropped ALL capabilities"; exit 0; fi
echo "Error: first dropped capability is '$d', expected ALL"; exit 1
