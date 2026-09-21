#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod graceful-pod -n tiger >/dev/null 2>&1; then echo "Success: pod graceful-pod exists"; exit 0; else echo "Error: pod graceful-pod not found"; exit 1; fi
