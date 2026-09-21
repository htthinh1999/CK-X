#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pod resource-aware -n fortress -o jsonpath='{.spec.containers[0].env[?(@.name=="MY_CPU_REQUEST")].valueFrom.resourceFieldRef.resource}' 2>/dev/null)
[ "$v" = "requests.cpu" ] && { echo "Success: MY_CPU_REQUEST maps to requests.cpu"; exit 0; }
echo "Error: MY_CPU_REQUEST resource is '$v', expected requests.cpu"; exit 1
