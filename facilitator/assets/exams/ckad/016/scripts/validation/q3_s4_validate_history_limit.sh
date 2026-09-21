#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
hl=$(kubectl get cronjob lightning-strike -n bolt -o jsonpath='{.spec.successfulJobsHistoryLimit}' 2>/dev/null)
if [ "$hl" = "2" ]; then echo "Success: successfulJobsHistoryLimit is 2"; exit 0; fi
echo "Error: successfulJobsHistoryLimit is '$hl', expected 2"; exit 1
