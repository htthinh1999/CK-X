#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get rolebinding log-rb -n marsh >/dev/null 2>&1; then echo "Success: rolebinding log-rb exists"; exit 0; else echo "Error: rolebinding log-rb not found in marsh"; exit 1; fi
