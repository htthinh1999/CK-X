#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl get pod process-monitor -n bastion >/dev/null 2>&1 && { echo "Success: pod process-monitor exists"; exit 0; }
echo "Error: pod process-monitor not found"; exit 1
