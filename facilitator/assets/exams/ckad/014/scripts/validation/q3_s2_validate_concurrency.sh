#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
conc=$(kubectl get cronjob nightly-backup -n twilight -o jsonpath='{.spec.concurrencyPolicy}' 2>/dev/null)
if [ "$conc" == "Forbid" ]; then
  echo "Success: concurrencyPolicy is Forbid"
  exit 0
else
  echo "Error: concurrencyPolicy is '$conc', expected Forbid"
  exit 1
fi
