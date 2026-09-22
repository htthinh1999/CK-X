#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod secure-app -n hades >/dev/null 2>&1; then echo "Success: pod secure-app exists"; exit 0; else echo "Error: pod secure-app not found in hades"; exit 1; fi
