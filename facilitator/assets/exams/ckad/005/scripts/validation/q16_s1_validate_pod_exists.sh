#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod hardened-pod -n predator >/dev/null 2>&1; then echo "Success: pod hardened-pod exists"; exit 0; else echo "Error: pod hardened-pod not found"; exit 1; fi
