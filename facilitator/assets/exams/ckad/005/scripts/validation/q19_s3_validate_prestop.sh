#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pod graceful-pod -n tiger -o jsonpath='{.spec.containers[0].lifecycle.preStop}' 2>/dev/null)
if [ -n "$v" ]; then echo "Success: preStop hook present"; exit 0; else echo "Error: preStop hook not found"; exit 1; fi
