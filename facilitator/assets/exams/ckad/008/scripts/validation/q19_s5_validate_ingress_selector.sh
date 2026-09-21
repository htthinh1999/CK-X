#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

s=$(kubectl get networkpolicy web-policy -n mist -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.access}' 2>/dev/null)
if [ "$s" = "granted" ]; then echo "Success: ingress from access=granted"; exit 0; else echo "Error: ingress selector access='$s'"; exit 1; fi
