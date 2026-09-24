#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod metadata-pod -n claw -o json 2>/dev/null | grep -q '"POD_NAMESPACE"'; then echo "Success: POD_NAMESPACE env present"; exit 0; else echo "Error: POD_NAMESPACE env not found"; exit 1; fi
