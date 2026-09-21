#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get cronjob backup-job -n pond -o jsonpath='{.spec.failedJobsHistoryLimit}' 2>/dev/null)
if [ "$v" = "2" ]; then echo "Success: failedJobsHistoryLimit is 2"; exit 0; else echo "Error: failedJobsHistoryLimit is '$v', expected 2"; exit 1; fi
