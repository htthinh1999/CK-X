#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
ip=$(kubectl get ep backend-svc -n gate -o jsonpath='{.subsets[0].addresses[0].ip}' 2>/dev/null)
if [ -n "$ip" ]; then echo "Success: backend-svc has endpoints ($ip)"; exit 0
else echo "Error: backend-svc has no endpoints"; exit 1; fi
