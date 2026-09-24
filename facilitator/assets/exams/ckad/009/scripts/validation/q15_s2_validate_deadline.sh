#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

d=$(kubectl get cronjob deadline-cron -n grove -o jsonpath='{.spec.startingDeadlineSeconds}' 2>/dev/null)
if [ "$d" = "17" ]; then
  echo "Success: startingDeadlineSeconds 17 correct"; exit 0
else
  echo "Error: startingDeadlineSeconds is '$d', expected 17"; exit 1
fi
