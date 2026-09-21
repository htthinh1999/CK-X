#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get deployment web-frontend -n coral -o yaml 2>/dev/null | grep -q "app: cache"; then echo "Success: app: cache selector"; exit 0; else echo "Error: app: cache selector - not found"; exit 1; fi
