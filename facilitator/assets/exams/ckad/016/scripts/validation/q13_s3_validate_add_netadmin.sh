#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
a=$(kubectl get pod secure-net -n bolt -o jsonpath='{.spec.containers[0].securityContext.capabilities.add[0]}' 2>/dev/null)
if [ "$a" = "NET_ADMIN" ]; then echo "Success: added NET_ADMIN capability"; exit 0; fi
echo "Error: first added capability is '$a', expected NET_ADMIN"; exit 1
