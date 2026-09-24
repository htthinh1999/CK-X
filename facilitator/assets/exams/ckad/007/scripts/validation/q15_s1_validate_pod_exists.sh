#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod data-pipeline -n anchor >/dev/null 2>&1; then echo "Success: pod data-pipeline exists in anchor"; exit 0; else echo "Error: pod data-pipeline not found in anchor"; exit 1; fi
