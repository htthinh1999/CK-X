#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

a=$(kubectl get deployment nginx-deploy -n valley -o jsonpath='{.status.availableReplicas}' 2>/dev/null)
if [ -n "$a" ] && [ "$a" -ge 1 ] 2>/dev/null; then echo "Success: $a available replicas"; exit 0; else echo "Error: available replicas=$a"; exit 1; fi
