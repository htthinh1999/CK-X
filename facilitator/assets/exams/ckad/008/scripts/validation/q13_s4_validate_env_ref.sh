#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

r=$(kubectl get pod config-pod -n summit -o jsonpath='{.spec.containers[0].env[?(@.name=="OPTION")].valueFrom.configMapKeyRef.name}' 2>/dev/null)
if [ "$r" = "options" ]; then echo "Success: OPTION references configmap options"; exit 0; else echo "Error: OPTION configMapKeyRef.name='$r'"; exit 1; fi
