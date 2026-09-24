#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
dls=$(kubectl get cronjob lightning-strike -n bolt -o jsonpath='{.spec.startingDeadlineSeconds}' 2>/dev/null)
if [ "$dls" = "15" ]; then echo "Success: startingDeadlineSeconds is 15"; exit 0; fi
echo "Error: startingDeadlineSeconds is '$dls', expected 15"; exit 1
