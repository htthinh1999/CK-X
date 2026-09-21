#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get deployment spread-pods -n tiger >/dev/null 2>&1; then echo "Success: deployment spread-pods exists"; exit 0; else echo "Error: deployment spread-pods not found"; exit 1; fi
