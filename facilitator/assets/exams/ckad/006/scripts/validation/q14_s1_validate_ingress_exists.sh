#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get ingress web-ingress -n eddy >/dev/null 2>&1; then echo "Success: ingress web-ingress exists"; exit 0; else echo "Error: ingress web-ingress not found in eddy"; exit 1; fi
