#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get deployment api-worker -n charge -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="APP_ENV")].value}' 2>/dev/null)
if [ "$v" = "production" ]; then echo "Success: APP_ENV=production applied"; exit 0; fi
echo "Error: APP_ENV is '$v', expected production"; exit 1
