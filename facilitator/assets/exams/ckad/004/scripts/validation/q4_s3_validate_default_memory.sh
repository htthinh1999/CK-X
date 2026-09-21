#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get limitrange resource-limits -n apollo -o jsonpath='{.spec.limits[0].default.memory}' 2>/dev/null)
if [ "$v" = "256Mi" ]; then echo "Success: default memory 256Mi"; exit 0; else echo "Error: default memory is '$v', expected 256Mi"; exit 1; fi
