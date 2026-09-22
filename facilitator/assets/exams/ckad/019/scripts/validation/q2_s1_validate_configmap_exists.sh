#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl get configmap init-script-cm -n fortress >/dev/null 2>&1 && { echo "Success: configmap init-script-cm exists"; exit 0; }
echo "Error: configmap init-script-cm not found"; exit 1
