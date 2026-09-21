#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get networkpolicy default-deny-all -n predator -o jsonpath='{.spec.podSelector}' 2>/dev/null)
if [ "$v" = "{}" ]; then echo "Success: applies to all pods"; exit 0; else echo "Error: podSelector='$v' expected {}"; exit 1; fi
