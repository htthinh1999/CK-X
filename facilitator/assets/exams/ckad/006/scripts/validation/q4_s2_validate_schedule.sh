#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get cronjob backup-job -n pond -o jsonpath='{.spec.schedule}' 2>/dev/null)
if [ "$v" = "*/30 * * * *" ]; then echo "Success: schedule is */30 * * * *"; exit 0; else echo "Error: schedule is '$v', expected */30 * * * *"; exit 1; fi
