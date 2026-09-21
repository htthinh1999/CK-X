#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get configmap locked-config -n hunt >/dev/null 2>&1; then echo "Success: configmap locked-config exists"; exit 0; else echo "Error: configmap locked-config not found"; exit 1; fi
