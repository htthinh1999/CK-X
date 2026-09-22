#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
r=$(kubectl get deployment stable-green -n stripe -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$r" = "3" ]; then echo "Success: replicas=3"; exit 0; else echo "Error: replicas='$r' expected 3"; exit 1; fi
