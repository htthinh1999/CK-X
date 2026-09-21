#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod slow-starter -n wave >/dev/null 2>&1; then echo "Success: pod slow-starter exists in wave"; exit 0; else echo "Error: pod slow-starter not found in wave"; exit 1; fi
