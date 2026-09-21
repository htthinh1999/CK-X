#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get deployment web-frontend -n coral >/dev/null 2>&1; then echo "Success: deployment web-frontend exists in coral"; exit 0; else echo "Error: deployment web-frontend not found in coral"; exit 1; fi
