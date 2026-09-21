#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get job parallel-processor -n current >/dev/null 2>&1; then echo "Success: job parallel-processor exists in current"; exit 0; else echo "Error: job parallel-processor not found in current"; exit 1; fi
