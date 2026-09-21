#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod multi-init -n poseidon >/dev/null 2>&1; then echo "Success: pod multi-init exists"; exit 0; else echo "Error: pod multi-init not found in poseidon"; exit 1; fi
