#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
s=$(kubectl get cronjob data-sync -n prowl -o jsonpath='{.spec.suspend}' 2>/dev/null)
if [ "$s" = "false" ] || [ -z "$s" ]; then echo "Success: cronjob not suspended"; exit 0; else echo "Error: suspend='$s' expected false"; exit 1; fi
