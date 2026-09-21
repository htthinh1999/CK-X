#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get cronjob backup-job -n pond -o jsonpath='{.spec.jobTemplate.spec.activeDeadlineSeconds}' 2>/dev/null)
if [ "$v" = "300" ]; then echo "Success: activeDeadlineSeconds is 300"; exit 0; else echo "Error: activeDeadlineSeconds is '$v', expected 300"; exit 1; fi
