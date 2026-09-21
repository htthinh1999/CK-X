#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get job cleanup-job -n stripe >/dev/null 2>&1; then echo "Success: job cleanup-job exists"; exit 0; fi
if [ -n "$(kubectl get pods -n stripe -l job-name=cleanup-job -o name 2>/dev/null)" ]; then echo "Success: cleanup-job pod exists"; exit 0; fi
echo "Error: job cleanup-job not found"; exit 1
