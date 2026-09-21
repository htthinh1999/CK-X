#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod cache-pod -n reef >/dev/null 2>&1; then echo "Success: pod cache-pod exists in reef"; exit 0; else echo "Error: pod cache-pod not found in reef"; exit 1; fi
