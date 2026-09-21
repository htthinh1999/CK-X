#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get cronjob data-sync -n prowl >/dev/null 2>&1; then echo "Success: cronjob data-sync exists"; exit 0; else echo "Error: cronjob data-sync not found"; exit 1; fi
