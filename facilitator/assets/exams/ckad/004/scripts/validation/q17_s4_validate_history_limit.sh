#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get cronjob scheduled-task -n ares -o jsonpath='{.spec.successfulJobsHistoryLimit}' 2>/dev/null)
if [ "$v" = "3" ]; then echo "Success: successfulJobsHistoryLimit 3"; exit 0; else echo "Error: successfulJobsHistoryLimit is '$v', expected 3"; exit 1; fi
