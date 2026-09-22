#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
s=$(kubectl get cronjob data-sync -n prowl -o jsonpath='{.spec.schedule}' 2>/dev/null)
if [ -n "$s" ]; then echo "Success: cronjob has schedule '$s'"; exit 0; else echo "Error: cronjob has no schedule"; exit 1; fi
