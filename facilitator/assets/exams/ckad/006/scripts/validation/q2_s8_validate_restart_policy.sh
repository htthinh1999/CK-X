#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get cronjob backup-job -n pond -o jsonpath='{.spec.jobTemplate.spec.template.spec.restartPolicy}' 2>/dev/null)
if [ "$v" = "Never" ]; then echo "Success: restartPolicy is Never"; exit 0; else echo "Error: restartPolicy is '$v', expected Never"; exit 1; fi
