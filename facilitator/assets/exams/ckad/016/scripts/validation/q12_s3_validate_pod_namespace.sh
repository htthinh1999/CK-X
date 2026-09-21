#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pod env-info -n thunder -o jsonpath='{.spec.containers[0].env[?(@.name=="POD_NAMESPACE")].valueFrom.fieldRef.fieldPath}' 2>/dev/null)
if [ "$v" = "metadata.namespace" ]; then echo "Success: POD_NAMESPACE mapped to metadata.namespace"; exit 0; fi
echo "Error: POD_NAMESPACE fieldPath is '$v', expected metadata.namespace"; exit 1
