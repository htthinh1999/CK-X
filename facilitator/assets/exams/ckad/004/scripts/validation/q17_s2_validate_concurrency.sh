#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get cronjob scheduled-task -n ares -o jsonpath='{.spec.concurrencyPolicy}' 2>/dev/null)
if [ "$v" = "Forbid" ]; then echo "Success: concurrencyPolicy Forbid"; exit 0; else echo "Error: concurrencyPolicy is '$v', expected Forbid"; exit 1; fi
