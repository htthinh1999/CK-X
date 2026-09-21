#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get job cleanup-job -n stripe -o jsonpath='{.spec.backoffLimit}' 2>/dev/null)
if [ "$v" = "2" ]; then echo "Success: backoffLimit 2"; exit 0; else echo "Error: backoffLimit='$v' expected 2"; exit 1; fi
