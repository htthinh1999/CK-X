#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
c=$(kubectl get cronjob data-sync -n prowl -o jsonpath='{.spec.concurrencyPolicy}' 2>/dev/null)
if [ "$c" = "Forbid" ]; then echo "Success: concurrencyPolicy=Forbid"; exit 0; else echo "Error: concurrencyPolicy='$c' expected Forbid"; exit 1; fi
