#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod limited-pod -n apollo >/dev/null 2>&1; then echo "Success: pod limited-pod exists"; exit 0; else echo "Error: pod limited-pod not found"; exit 1; fi
