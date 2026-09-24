#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get cronjob backup-job -n pond -o jsonpath='{.spec.jobTemplate.spec.template.spec.containers[0].name}' 2>/dev/null)
if [ "$v" = "backup" ]; then echo "Success: container name is backup"; exit 0; else echo "Error: container name is '$v', expected backup"; exit 1; fi
