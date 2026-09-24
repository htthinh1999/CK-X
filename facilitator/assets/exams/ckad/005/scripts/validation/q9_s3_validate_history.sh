#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get deployment rolling-app -n pounce -o jsonpath='{.spec.revisionHistoryLimit}' 2>/dev/null)
if [ "$v" = "5" ]; then echo "Success: revisionHistoryLimit 5"; exit 0; else echo "Error: revisionHistoryLimit='$v' expected 5"; exit 1; fi
