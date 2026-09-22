#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

s=$(kubectl get cronjob date-job -n mist -o jsonpath='{.spec.schedule}' 2>/dev/null)
if [ "$s" = "*/1 * * * *" ] || [ "$s" = "* * * * *" ]; then echo "Success: schedule is $s"; exit 0; else echo "Error: schedule is '$s'"; exit 1; fi
