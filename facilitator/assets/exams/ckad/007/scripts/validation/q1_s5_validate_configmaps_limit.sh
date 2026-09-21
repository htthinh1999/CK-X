#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get resourcequota namespace-limits -n shell -o jsonpath='{.spec.hard.configmaps}' 2>/dev/null)
if [ "$val" = "10" ]; then echo "Success: configmaps limit is 10"; exit 0; else echo "Error: configmaps limit is '$val', expected 10"; exit 1; fi
