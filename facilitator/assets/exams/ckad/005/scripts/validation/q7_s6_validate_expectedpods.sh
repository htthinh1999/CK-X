#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pdb critical-pdb -n jungle -o jsonpath='{.status.expectedPods}' 2>/dev/null)
if [ "$v" = "5" ]; then echo "Success: expectedPods=5"; exit 0; else echo "Error: expectedPods='$v' expected 5"; exit 1; fi
