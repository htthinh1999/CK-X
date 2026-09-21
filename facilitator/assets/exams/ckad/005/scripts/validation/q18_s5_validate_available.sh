#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get deployment safe-deploy -n fang -o jsonpath='{.status.conditions[?(@.type=="Available")].status}' 2>/dev/null)
if [ "$v" = "True" ]; then echo "Success: deployment available"; exit 0; else echo "Error: Available='$v' expected True"; exit 1; fi
