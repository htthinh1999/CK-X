#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
d=$(kubectl get cronjob data-sync -n prowl -o jsonpath='{.spec.startingDeadlineSeconds}' 2>/dev/null)
if [ "$d" = "200" ]; then echo "Success: startingDeadlineSeconds=200"; exit 0; else echo "Error: startingDeadlineSeconds='$d' expected 200"; exit 1; fi
