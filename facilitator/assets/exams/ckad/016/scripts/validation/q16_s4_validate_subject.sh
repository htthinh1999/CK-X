#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
s=$(kubectl get clusterrolebinding secret-reader-binding -o jsonpath='{.subjects[0].name}' 2>/dev/null)
if [ "$s" = "app-sa" ]; then echo "Success: bound to app-sa"; exit 0; fi
echo "Error: subject name is '$s', expected app-sa"; exit 1
