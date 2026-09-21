#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get networkpolicy default-deny-all -n predator >/dev/null 2>&1; then echo "Success: networkpolicy default-deny-all exists"; exit 0; else echo "Error: networkpolicy default-deny-all not found"; exit 1; fi
