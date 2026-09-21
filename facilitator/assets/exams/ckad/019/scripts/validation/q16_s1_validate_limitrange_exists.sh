#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl get limitrange rampart-limits -n rampart >/dev/null 2>&1 && { echo "Success: limitrange rampart-limits exists"; exit 0; }
echo "Error: limitrange rampart-limits not found"; exit 1
