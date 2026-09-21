#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pdb critical-pdb -n jungle -o jsonpath='{.spec.minAvailable}' 2>/dev/null)
if [ "$v" = "3" ]; then echo "Success: minAvailable=3"; exit 0; else echo "Error: minAvailable='$v' expected 3"; exit 1; fi
