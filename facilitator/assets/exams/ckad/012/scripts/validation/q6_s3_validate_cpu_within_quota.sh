#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
req=$(kubectl get deployment quota-app -n garrison -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}' 2>/dev/null)
if [ -z "$req" ]; then echo "Error: no CPU requests set"; exit 1; fi
case "$req" in
  *m) cpu_m="${req%m}";;
  *) cpu_m=$((req * 1000));;
esac
if [ "$cpu_m" -le 500 ] 2>/dev/null; then echo "Success: CPU requests within quota ($req)"; exit 0
else echo "Error: CPU requests exceed quota ($req)"; exit 1; fi
