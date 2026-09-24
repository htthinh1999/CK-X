#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pdb critical-pdb -n jungle -o jsonpath='{.apiVersion}' 2>/dev/null)
if [ "$v" = "policy/v1" ]; then echo "Success: apiVersion policy/v1"; exit 0; else echo "Error: apiVersion='$v' expected policy/v1"; exit 1; fi
