#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get deploy secure-app -n cascade >/dev/null 2>&1; then echo "Success: deployment secure-app exists"; exit 0; else echo "Error: deployment secure-app not found in cascade"; exit 1; fi
