#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod critical-pod -n tide >/dev/null 2>&1; then echo "Success: pod critical-pod exists in tide"; exit 0; else echo "Error: pod critical-pod not found in tide"; exit 1; fi
