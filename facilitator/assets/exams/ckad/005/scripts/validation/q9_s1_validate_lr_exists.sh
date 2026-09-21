#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get limitrange container-limits -n pounce >/dev/null 2>&1; then echo "Success: limitrange container-limits exists"; exit 0; else echo "Error: limitrange container-limits not found"; exit 1; fi
