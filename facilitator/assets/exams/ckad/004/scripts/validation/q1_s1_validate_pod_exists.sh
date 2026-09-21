#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod titan-alpha -n zeus >/dev/null 2>&1; then echo "Success: pod titan-alpha exists"; exit 0; else echo "Error: pod titan-alpha not found in zeus"; exit 1; fi
