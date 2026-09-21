#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pdb critical-pdb -n jungle >/dev/null 2>&1; then echo "Success: pdb critical-pdb exists"; exit 0; else echo "Error: pdb critical-pdb not found"; exit 1; fi
