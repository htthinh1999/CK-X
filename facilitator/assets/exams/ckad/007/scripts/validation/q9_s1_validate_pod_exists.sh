#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod network-diagnostic -n coral >/dev/null 2>&1; then echo "Success: pod network-diagnostic exists in coral"; exit 0; else echo "Error: pod network-diagnostic not found in coral"; exit 1; fi
