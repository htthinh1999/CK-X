#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get job retry-job -n artemis >/dev/null 2>&1; then echo "Success: job retry-job exists"; exit 0; else echo "Error: job retry-job not found in artemis"; exit 1; fi
