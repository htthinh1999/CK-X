#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get cronjob scheduled-task -n ares -o jsonpath='{.spec.schedule}' 2>/dev/null)
if [ "$v" = "*/5 * * * *" ]; then echo "Success: schedule correct"; exit 0; else echo "Error: schedule is '$v', expected */5 * * * *"; exit 1; fi
