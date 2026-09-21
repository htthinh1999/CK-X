#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get networkpolicy egress-policy -n athena -o jsonpath='{.spec.podSelector.matchLabels.app}' 2>/dev/null)
if [ "$v" = "restricted" ]; then echo "Success: podSelector app=restricted"; exit 0; else echo "Error: podSelector app is '$v', expected restricted"; exit 1; fi
