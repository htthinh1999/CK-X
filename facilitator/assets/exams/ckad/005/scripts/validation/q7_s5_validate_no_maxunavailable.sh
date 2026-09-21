#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pdb critical-pdb -n jungle -o jsonpath='{.spec.maxUnavailable}' 2>/dev/null)
if [ -z "$v" ]; then echo "Success: maxUnavailable not set"; exit 0; else echo "Error: maxUnavailable='$v' should not be set"; exit 1; fi
