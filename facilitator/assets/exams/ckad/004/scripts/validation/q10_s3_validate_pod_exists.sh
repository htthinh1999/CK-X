#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod private-app -n hera >/dev/null 2>&1; then echo "Success: pod private-app exists"; exit 0; else echo "Error: pod private-app not found"; exit 1; fi
