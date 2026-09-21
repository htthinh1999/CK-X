#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get cronjob backup-job -n pond >/dev/null 2>&1; then echo "Success: cronjob backup-job exists"; exit 0; else echo "Error: cronjob backup-job not found in pond"; exit 1; fi
