#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get job cleanup-job -n stripe -o jsonpath='{.spec.ttlSecondsAfterFinished}' 2>/dev/null)
if [ "$v" = "60" ]; then echo "Success: ttlSecondsAfterFinished 60"; exit 0; else echo "Error: ttlSecondsAfterFinished='$v' expected 60"; exit 1; fi
