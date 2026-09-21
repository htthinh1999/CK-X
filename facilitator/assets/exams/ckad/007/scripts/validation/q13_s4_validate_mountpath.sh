#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod cache-pod -n reef -o jsonpath='{.spec.containers[0].volumeMounts[*].mountPath}' 2>/dev/null | grep -q "/cache"; then echo "Success: mountPath /cache"; exit 0; else echo "Error: mountPath /cache - not found"; exit 1; fi
