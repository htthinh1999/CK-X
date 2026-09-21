#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
stable=$(kubectl get pods -n bulwark -l app=webapp,version=v1 --no-headers 2>/dev/null | wc -l)
canary=$(kubectl get pods -n bulwark -l app=webapp,version=v2 --no-headers 2>/dev/null | wc -l)
if [ "$canary" -ge 1 ] && [ "$stable" -ge 1 ]; then echo "Success: service routes to both stable ($stable) and canary ($canary)"; exit 0
else echo "Error: not routing to both versions (stable=$stable, canary=$canary)"; exit 1; fi
