#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod secure-pod -n stalker >/dev/null 2>&1; then echo "Success: pod secure-pod exists"; exit 0; else echo "Error: pod secure-pod not found"; exit 1; fi
