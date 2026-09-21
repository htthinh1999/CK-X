#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
ref=$(kubectl get pod config-app -n gate -o jsonpath='{.spec.containers[0].envFrom[0].configMapRef.name}' 2>/dev/null)
if [ "$ref" = "app-config" ]; then echo "Success: envFrom configMapRef is app-config"; exit 0; fi
src=$(kubectl get pod config-app -n gate -o jsonpath='{.spec.containers[0].env[*].valueFrom.configMapKeyRef.name}' 2>/dev/null)
case "$src" in
  *app-config*) echo "Success: configMapKeyRef used for app-config"; exit 0;;
  *) echo "Error: Pod does not reference ConfigMap app-config"; exit 1;;
esac
