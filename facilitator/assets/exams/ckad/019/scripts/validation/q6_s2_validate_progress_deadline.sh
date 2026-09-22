#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
pds=$(kubectl get deploy citadel-guard -n citadel -o jsonpath='{.spec.progressDeadlineSeconds}' 2>/dev/null)
[ "$pds" = "15" ] && { echo "Success: progressDeadlineSeconds is 15"; exit 0; }
echo "Error: progressDeadlineSeconds is '$pds', expected 15"; exit 1
