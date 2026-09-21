#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pod token-pod -n hades -o jsonpath='{.spec.volumes[0].projected}' 2>/dev/null)
if [ -n "$v" ]; then echo "Success: projected volume configured"; exit 0; else echo "Error: projected volume missing"; exit 1; fi
