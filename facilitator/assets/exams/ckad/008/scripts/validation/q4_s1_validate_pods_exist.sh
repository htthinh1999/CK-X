#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

c=0; for p in nginx1 nginx2 nginx3; do kubectl get pod "$p" -n ridge >/dev/null 2>&1 && c=$((c+1)); done
if [ "$c" -eq 3 ]; then echo "Success: all 3 pods exist"; exit 0; else echo "Error: only $c/3 pods found"; exit 1; fi
