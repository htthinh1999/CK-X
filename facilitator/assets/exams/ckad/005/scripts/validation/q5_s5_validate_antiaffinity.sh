#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
a=$(kubectl get deployment spread-pods -n tiger -o jsonpath='{.spec.template.spec.affinity.podAntiAffinity}' 2>/dev/null)
if [ -n "$a" ]; then echo "Success: pod anti-affinity configured"; exit 0; else echo "Error: pod anti-affinity not configured"; exit 1; fi
