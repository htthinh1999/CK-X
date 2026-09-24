#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get cronjob scheduled-task -n ares >/dev/null 2>&1; then echo "Success: cronjob scheduled-task exists"; exit 0; else echo "Error: cronjob scheduled-task not found in ares"; exit 1; fi
