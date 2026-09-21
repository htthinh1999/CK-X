#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get hpa web-app-hpa -n ocean >/dev/null 2>&1; then echo "Success: hpa web-app-hpa exists in ocean"; exit 0; else echo "Error: hpa web-app-hpa not found in ocean"; exit 1; fi
