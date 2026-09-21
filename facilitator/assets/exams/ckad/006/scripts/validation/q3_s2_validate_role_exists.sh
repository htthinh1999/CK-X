#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get role log-role -n marsh >/dev/null 2>&1; then echo "Success: role log-role exists"; exit 0; else echo "Error: role log-role not found in marsh"; exit 1; fi
