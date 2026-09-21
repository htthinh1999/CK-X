#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get secret app-credentials -n deep >/dev/null 2>&1; then echo "Success: secret app-credentials exists in deep"; exit 0; else echo "Error: secret app-credentials not found in deep"; exit 1; fi
