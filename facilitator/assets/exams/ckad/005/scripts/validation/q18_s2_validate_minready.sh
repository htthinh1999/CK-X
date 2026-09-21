#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get deployment safe-deploy -n fang -o jsonpath='{.spec.minReadySeconds}' 2>/dev/null)
if [ "$v" = "30" ]; then echo "Success: minReadySeconds 30"; exit 0; else echo "Error: minReadySeconds='$v' expected 30"; exit 1; fi
