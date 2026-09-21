#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pod metrics-pod -n delta -o jsonpath='{.spec.serviceAccountName}' 2>/dev/null)
if [ "$v" = "monitor-sa" ]; then echo "Success: pod uses monitor-sa"; exit 0; else echo "Error: pod SA is '$v', expected monitor-sa"; exit 1; fi
