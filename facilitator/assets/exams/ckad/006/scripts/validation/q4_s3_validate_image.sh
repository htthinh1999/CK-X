#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get cronjob backup-job -n pond -o jsonpath='{.spec.jobTemplate.spec.template.spec.containers[0].image}' 2>/dev/null)
if [[ "$v" == *"busybox"* ]]; then echo "Success: image is $v"; exit 0; else echo "Error: image is '$v', expected busybox:latest"; exit 1; fi
