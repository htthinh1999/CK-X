#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pod resource-aware -n fortress -o jsonpath='{.spec.containers[0].env[?(@.name=="MY_MEM_LIMIT")].valueFrom.resourceFieldRef.resource}' 2>/dev/null)
[ "$v" = "limits.memory" ] && { echo "Success: MY_MEM_LIMIT maps to limits.memory"; exit 0; }
echo "Error: MY_MEM_LIMIT resource is '$v', expected limits.memory"; exit 1
