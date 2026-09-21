#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
ml=$(kubectl get pod data-processor -n sentinel -o jsonpath='{.spec.containers[0].resources.limits.memory}' 2>/dev/null)
[ "$ml" = "256Mi" ] && { echo "Success: memory limit is 256Mi"; exit 0; }
echo "Error: memory limit is '$ml', expected 256Mi"; exit 1
