#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod resource-pod -n pond >/dev/null 2>&1; then echo "Success: pod resource-pod exists"; exit 0; else echo "Error: pod resource-pod not found in pond"; exit 1; fi
