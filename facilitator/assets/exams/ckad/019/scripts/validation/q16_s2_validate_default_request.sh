#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
mr=$(kubectl get pod default-pod -n rampart -o jsonpath='{.spec.containers[0].resources.requests.memory}' 2>/dev/null)
[ "$mr" = "256Mi" ] && { echo "Success: default-pod memory request is 256Mi"; exit 0; }
echo "Error: default-pod memory request is '$mr', expected 256Mi"; exit 1
