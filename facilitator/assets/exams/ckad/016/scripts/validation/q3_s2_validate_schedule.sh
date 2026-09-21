#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
sched=$(kubectl get cronjob lightning-strike -n bolt -o jsonpath='{.spec.schedule}' 2>/dev/null)
if [[ "$sched" == *"*/5 * * * *"* ]]; then echo "Success: schedule correct"; exit 0; fi
echo "Error: schedule is '$sched', expected */5 * * * *"; exit 1
