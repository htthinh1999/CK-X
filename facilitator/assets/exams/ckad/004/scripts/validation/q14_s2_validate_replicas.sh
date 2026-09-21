#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get deployment rolling-app -n apollo -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$v" = "4" ]; then echo "Success: replicas 4"; exit 0; else echo "Error: replicas is '$v', expected 4"; exit 1; fi
