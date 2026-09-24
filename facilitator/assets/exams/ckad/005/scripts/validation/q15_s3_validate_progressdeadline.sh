#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get deployment safe-deploy -n fang -o jsonpath='{.spec.progressDeadlineSeconds}' 2>/dev/null)
if [ "$v" = "120" ]; then echo "Success: progressDeadlineSeconds 120"; exit 0; else echo "Error: progressDeadlineSeconds='$v' expected 120"; exit 1; fi
