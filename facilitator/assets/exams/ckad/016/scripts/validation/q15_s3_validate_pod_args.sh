#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
a=$(kubectl get pod arg-reader -n voltage -o jsonpath='{.spec.containers[0].args}' 2>/dev/null)
if [ -n "$a" ]; then echo "Success: pod args configured"; exit 0; fi
echo "Error: pod args not configured"; exit 1
