#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pdb app-pdb -n hera >/dev/null 2>&1; then echo "Success: pdb app-pdb exists"; exit 0; else echo "Error: pdb app-pdb not found in hera"; exit 1; fi
