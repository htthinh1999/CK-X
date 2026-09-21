#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
e=$(kubectl get configmap app-config -n gate -o jsonpath='{.data.APP_ENV}' 2>/dev/null)
d=$(kubectl get configmap app-config -n gate -o jsonpath='{.data.APP_DEBUG}' 2>/dev/null)
if [ "$e" = "production" ] && [ "$d" = "false" ]; then echo "Success: ConfigMap keys correct"; exit 0
else echo "Error: ConfigMap keys incorrect (APP_ENV=$e, APP_DEBUG=$d)"; exit 1; fi
