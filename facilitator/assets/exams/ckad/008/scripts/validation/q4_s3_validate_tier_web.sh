#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

t1=$(kubectl get pod nginx1 -n ridge -o jsonpath='{.metadata.labels.tier}' 2>/dev/null)
t3=$(kubectl get pod nginx3 -n ridge -o jsonpath='{.metadata.labels.tier}' 2>/dev/null)
if [ "$t1" = "web" ] && [ "$t3" = "web" ]; then echo "Success: nginx1 and nginx3 have tier=web"; exit 0; else echo "Error: nginx1 tier=$t1 nginx3 tier=$t3"; exit 1; fi
