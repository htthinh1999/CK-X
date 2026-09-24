#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
i=$(kubectl get cronjob data-sync -n prowl -o jsonpath='{.spec.jobTemplate.spec.template.spec.containers[0].image}' 2>/dev/null)
if [ -n "$i" ]; then echo "Success: cronjob has container image '$i'"; exit 0; else echo "Error: cronjob has no container image"; exit 1; fi
